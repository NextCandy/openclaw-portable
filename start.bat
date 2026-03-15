@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable v5.0.3

echo.
echo ==========================================
echo   OpenClaw Portable v5.0.3 - Offline Edition
echo ==========================================
echo.

rem === Resolve script directory ===
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

rem === Path configuration ===
set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "OPENCLAW_ENTRY_LINUX=%SCRIPT_DIR%\openclaw-pkg\lib\node_modules\openclaw\openclaw.mjs"
set "OPENCLAW_ENTRY_WINDOWS=%SCRIPT_DIR%\openclaw-pkg\node_modules\openclaw\openclaw.mjs"

if exist "%OPENCLAW_ENTRY_LINUX%" (
    set "OPENCLAW_ENTRY=%OPENCLAW_ENTRY_LINUX%"
    echo [INFO] Using Linux npm path
) else if exist "%OPENCLAW_ENTRY_WINDOWS%" (
    set "OPENCLAW_ENTRY=%OPENCLAW_ENTRY_WINDOWS%"
    echo [INFO] Using Windows npm path
) else (
    set "OPENCLAW_ENTRY=%OPENCLAW_ENTRY_LINUX%"
)

set "OPENCLAW_HOME=%SCRIPT_DIR%\data"
set "GATEWAY_PORT=18789"
set "PATH=%SCRIPT_DIR%\node;%PATH%"

echo [INFO] Script dir : %SCRIPT_DIR%
echo [INFO] Node dir   : %SCRIPT_DIR%\node
echo [INFO] Data dir   : %OPENCLAW_HOME%
echo.

rem ============================================
rem [1/5] Check Node.js
rem ============================================
echo [1/5] Checking Node.js...

if not exist "%NODE_EXE%" (
    echo.
    echo [ERROR] node\node.exe not found!
    echo.
    echo This is an OFFLINE package. Node.js should be pre-bundled.
    echo Please verify you downloaded the correct offline package.
    echo.
    echo If you want to use online bootstrap mode, use: start-online.bat
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
echo [OK]  Node.js !NODE_VER! is ready

rem ============================================
rem [2/5] Check OpenClaw
rem ============================================
echo.
echo [2/5] Checking OpenClaw...

if not exist "%OPENCLAW_ENTRY%" (
    echo.
    echo [ERROR] openclaw.mjs not found!
    echo.
    echo This is an OFFLINE package. OpenClaw should be pre-bundled.
    echo Please verify you downloaded the correct offline package.
    echo.
    pause
    exit /b 1
)

echo [OK]  OpenClaw is ready

rem ============================================
rem [3/5] Check port availability
rem ============================================
echo.
echo [3/5] Checking port...

netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [WARN] Port %GATEWAY_PORT% is in use, trying backup port 18790...
    set "GATEWAY_PORT=18790"
    netstat -aon 2>nul | findstr ":18790" | findstr "LISTENING" >nul
    if not errorlevel 1 (
        echo [ERROR] Fallback port 18790 is also in use.
        echo         Please edit GATEWAY_PORT in start.bat manually.
        pause
        exit /b 1
    )
)

echo [OK]  Port %GATEWAY_PORT% is available

rem ============================================
rem [4/5] Setup environment
rem ============================================
echo.
echo [4/5] Setting up environment...

if not exist "%SCRIPT_DIR%\data" mkdir "%SCRIPT_DIR%\data"
if not exist "%SCRIPT_DIR%\workspace" mkdir "%SCRIPT_DIR%\workspace"
if not exist "%SCRIPT_DIR%\temp" mkdir "%SCRIPT_DIR%\temp"

echo [OK]  Environment is ready

rem ============================================
rem [5/5] Start OpenClaw Gateway
rem ============================================
echo.
echo [5/5] Starting OpenClaw Gateway...
echo.

rem Start OpenClaw Gateway (background)
start /b "" "%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run --port %GATEWAY_PORT% --allow-unconfigured

rem Wait for startup (max 10 seconds)
echo [INFO] Waiting for Gateway to start...
set WAIT_COUNT=0
:wait_loop
timeout /t 1 /nobreak >nul
set /a WAIT_COUNT+=1

rem Check if port is listening
netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [OK]  Gateway is running on port %GATEWAY_PORT%
    goto :gateway_started
)

rem Timeout after 10 seconds
if %WAIT_COUNT% LSS 10 goto :wait_loop

echo [ERROR] Gateway failed to start within 10 seconds
pause
exit /b 1

:gateway_started
echo.

rem ============================================
rem Extract and display token
rem ============================================
set "CONFIG_FILE=%OPENCLAW_HOME%\.openclaw\openclaw.json"
set GATEWAY_TOKEN=

rem Wait for config file to be created (max 5 seconds)
set WAIT_COUNT=0
:wait_config
if exist "%CONFIG_FILE%" goto :read_token
timeout /t 1 /nobreak >nul
set /a WAIT_COUNT+=1
if %WAIT_COUNT% LSS 5 goto :wait_config
echo [WARN] Config file not found, token extraction skipped
goto :show_url

:read_token
rem Extract token from JSON using findstr
for /f "tokens=2 delims=:" %%a in ('findstr /C:"\"token\"" "%CONFIG_FILE%" 2^>nul') do (
    set "TOKEN_LINE=%%a"
    rem Remove quotes and commas
    set "TOKEN_LINE=!TOKEN_LINE:"=!"
    set "TOKEN_LINE=!TOKEN_LINE:,=!"
    set "TOKEN_LINE=!TOKEN_LINE: =!"
    set "GATEWAY_TOKEN=!TOKEN_LINE!"
)

:show_url
echo ==========================================
echo   Gateway is ready!
echo ==========================================
echo.
echo   Access URL: http://localhost:%GATEWAY_PORT%
echo.

if defined GATEWAY_TOKEN (
    echo   Token: !GATEWAY_TOKEN!
    echo.
    
    rem Copy token to clipboard (Windows Vista+)
    echo !GATEWAY_TOKEN! | clip >nul 2>&1
    if not errorlevel 1 (
        echo   [OK] Token copied to clipboard
    ) else (
        echo   [INFO] Copy token manually if needed
    )
    
    echo.
    echo   Direct link (with token):
    echo   http://localhost:%GATEWAY_PORT%?token=!GATEWAY_TOKEN!
    echo.
    
    rem Auto-open browser with token
    start http://localhost:%GATEWAY_PORT%?token=!GATEWAY_TOKEN!
) else (
    echo   [INFO] Token not found in config file
    echo   You can find it in: %CONFIG_FILE%
    echo.
    
    rem Auto-open browser without token
    start http://localhost:%GATEWAY_PORT%
)

echo.
echo ==========================================
echo   To stop: Close this window or press Ctrl+C
echo ==========================================
echo.

rem Keep the window open and show logs
:keep_running
timeout /t 60 /nobreak >nul
goto :keep_running
