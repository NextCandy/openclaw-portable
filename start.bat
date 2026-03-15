@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable v6.0.0

echo.
echo ==========================================
echo   OpenClaw Portable v6.0.0 - Offline Edition
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

rem ============================================
rem Wait for Gateway to be ready (up to 60 seconds)
rem ============================================
echo [INFO] Waiting for Gateway to start...
echo [INFO] This may take up to 60 seconds on first run...
echo.

set "CONFIG_FILE=%OPENCLAW_HOME%\.openclaw\openclaw.json"
set GATEWAY_TOKEN=
set GATEWAY_READY=0
set WAIT_COUNT=0

:wait_loop
timeout /t 1 /nobreak >nul
set /a WAIT_COUNT+=1

rem Check if port is listening
netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if not errorlevel 1 (
    set GATEWAY_READY=1
)

rem Try to extract token if config file exists
if exist "%CONFIG_FILE%" (
    if not defined GATEWAY_TOKEN (
        for /f "tokens=2 delims=:" %%a in ('findstr /C:"\"token\"" "%CONFIG_FILE%" 2^>nul') do (
            set "TOKEN_LINE=%%a"
            set "TOKEN_LINE=!TOKEN_LINE:"=!"
            set "TOKEN_LINE=!TOKEN_LINE:,=!"
            set "TOKEN_LINE=!TOKEN_LINE: =!"
            set "GATEWAY_TOKEN=!TOKEN_LINE!"
        )
    )
)

rem Ready if both port is listening AND (token found OR waited 30+ seconds)
if !GATEWAY_READY! EQU 1 (
    if defined GATEWAY_TOKEN goto :gateway_ready
    if !WAIT_COUNT! GEQ 30 goto :gateway_ready
)

rem Show progress every 5 seconds
set /a MOD=!WAIT_COUNT! %% 5
if !MOD! EQU 0 (
    echo [INFO] Still waiting... (!WAIT_COUNT!/60 seconds^)
)

rem Timeout after 60 seconds
if !WAIT_COUNT! LSS 60 goto :wait_loop

echo.
echo [WARN] Gateway startup timeout (60 seconds^)
echo [INFO] Gateway may still be starting in the background
echo.

:gateway_ready
echo.
if !GATEWAY_READY! EQU 1 (
    echo [OK]  Gateway is running on port %GATEWAY_PORT%
) else (
    echo [INFO] Gateway is still starting...
)
echo.

rem ============================================
rem Display access information
rem ============================================
echo ==========================================
echo   Gateway is ready!
echo ==========================================
echo.
echo   Access URL: http://localhost:%GATEWAY_PORT%
echo.

if defined GATEWAY_TOKEN (
    echo   Token: !GATEWAY_TOKEN!
    echo.
    
    rem Copy token to clipboard using PowerShell (more reliable)
    powershell -NoProfile -Command "Set-Clipboard -Value '!GATEWAY_TOKEN!'" 2>nul
    if not errorlevel 1 (
        echo   [OK] Token copied to clipboard
    ) else (
        echo   [INFO] Copy token manually if needed
    )
    
    echo.
    echo   Direct link with token:
    echo   http://localhost:%GATEWAY_PORT%?token=!GATEWAY_TOKEN!
    echo.
    
    rem Auto-open browser with token
    start http://localhost:%GATEWAY_PORT%?token=!GATEWAY_TOKEN!
) else (
    echo   [INFO] Token not found yet, will retry in 5 seconds...
    echo.
    
    rem Wait a bit more for token
    timeout /t 5 /nobreak >nul
    
    rem Retry token extraction
    if exist "%CONFIG_FILE%" (
        for /f "tokens=2 delims=:" %%a in ('findstr /C:"\"token\"" "%CONFIG_FILE%" 2^>nul') do (
            set "TOKEN_LINE=%%a"
            set "TOKEN_LINE=!TOKEN_LINE:"=!"
            set "TOKEN_LINE=!TOKEN_LINE:,=!"
            set "TOKEN_LINE=!TOKEN_LINE: =!"
            set "GATEWAY_TOKEN=!TOKEN_LINE!"
        )
    )
    
    if defined GATEWAY_TOKEN (
        echo   Token: !GATEWAY_TOKEN!
        echo.
        powershell -NoProfile -Command "Set-Clipboard -Value '!GATEWAY_TOKEN!'" 2>nul
        echo   [OK] Token copied to clipboard
        echo.
        echo   Direct link with token:
        echo   http://localhost:%GATEWAY_PORT%?token=!GATEWAY_TOKEN!
        echo.
        start http://localhost:%GATEWAY_PORT%?token=!GATEWAY_TOKEN!
    ) else (
        echo   [WARN] Token still not found
        echo   Config path: %CONFIG_FILE%
        echo.
        echo   Opening browser without token...
        start http://localhost:%GATEWAY_PORT%
    )
)

echo.
echo ==========================================
echo   To stop: Close this window or press Ctrl+C
echo ==========================================
echo.

rem Keep the window open
:keep_running
timeout /t 60 /nobreak >nul
goto :keep_running
