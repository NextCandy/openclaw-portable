@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable v5.0.4 (Online)

echo.
echo ==========================================
echo   OpenClaw Portable v5.0.4 - Online Edition
echo   First run requires internet (~60MB)
echo ==========================================
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "NPM_CLI=%SCRIPT_DIR%\node\node_modules\npm\bin\npm-cli.js"
set "OPENCLAW_ENTRY=%SCRIPT_DIR%\openclaw-pkg\node_modules\openclaw\bin\openclaw"
set "GATEWAY_PORT=18789"

rem ============================================
rem [1/4] Download Node.js (if needed)
rem ============================================
echo [1/4] Checking Node.js...

if exist "%NODE_EXE%" (
    for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do echo [OK]  Node.js %%v already exists
    goto :check_openclaw
)

echo [INFO] Node.js not found, downloading (~30MB)...
echo [INFO] Using China mirror for faster download...

set "NODE_URL=https://npmmirror.com/mirrors/node/v22.16.0/node-v22.16.0-win-x64.zip"

rem Use Windows 10+ built-in curl.exe
curl -fsSL "%NODE_URL%" -o "%SCRIPT_DIR%\node.zip"

if errorlevel 1 (
    echo [ERROR] Download failed
    echo         Please check your internet connection
    pause
    exit /b 1
)

echo [INFO] Extracting...
powershell -NoProfile -Command "Expand-Archive -Path '%SCRIPT_DIR%\node.zip' -DestinationPath '%SCRIPT_DIR%\node_tmp' -Force"
move "%SCRIPT_DIR%\node_tmp\node-v22.16.0-win-x64" "%SCRIPT_DIR%\node"
del /f /q "%SCRIPT_DIR%\node.zip"
rd /s /q "%SCRIPT_DIR%\node_tmp"

for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do echo [OK]  Node.js %%v downloaded

:check_openclaw
rem ============================================
rem [2/4] Install OpenClaw (if needed)
rem ============================================
echo.
echo [2/4] Checking OpenClaw...

if exist "%OPENCLAW_ENTRY%" (
    echo [OK]  OpenClaw already exists
    goto :check_port
)

echo [INFO] OpenClaw not found, installing (~30MB)...
echo [INFO] Using China mirror for faster download...

mkdir "%SCRIPT_DIR%\openclaw-pkg"

"%NODE_EXE%" "%NPM_CLI%" install -g openclaw --prefix "%SCRIPT_DIR%\openclaw-pkg" --registry https://registry.npmmirror.com

if errorlevel 1 (
    echo [ERROR] Installation failed
    echo         Please check your internet connection
    pause
    exit /b 1
)

echo [OK]  OpenClaw installed

:check_port
rem ============================================
rem [3/4] Check port
rem ============================================
echo.
echo [3/4] Checking port...

netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [WARN] Port %GATEWAY_PORT% is in use, trying backup port...
    set "GATEWAY_PORT=18790"
)

echo [OK]  Using port %GATEWAY_PORT%

rem ============================================
rem [4/4] Start
rem ============================================
echo.
echo [4/4] Starting OpenClaw Gateway...
echo.

if not exist "%SCRIPT_DIR%\data" mkdir "%SCRIPT_DIR%\data"

rem Start OpenClaw Gateway (background)
start /b "" "%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run --port %GATEWAY_PORT%

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
set "CONFIG_FILE=%SCRIPT_DIR%\data\.openclaw\openclaw.json"
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
    echo   [INFO] Token not found in config file
    echo   Config path: %CONFIG_FILE%
    echo.
    
    rem Auto-open browser without token
    start http://localhost:%GATEWAY_PORT%
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
