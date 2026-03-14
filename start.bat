@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable v5.0

echo.
echo ==========================================
echo   OpenClaw Portable v5.0 - Offline Edition
echo ==========================================
echo.

rem === Resolve script directory ===
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

rem === Path configuration ===
set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "NPM_CLI=%SCRIPT_DIR%\node\node_modules\npm\bin\npm-cli.js"

rem OpenClaw entry file (openclaw.mjs, NOT bin/openclaw)
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
set "PATH=%SCRIPT_DIR%\node;%SCRIPT_DIR%\openclaw-pkg\node_modules\.bin;%SCRIPT_DIR%\openclaw-pkg\lib\node_modules\.bin;%PATH%"

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
    pause
    exit /b 1
)

echo [OK]  OpenClaw is ready

rem ============================================
rem [3/5] Check port
rem ============================================
echo.
echo [3/5] Checking port...

netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [WARN] Port %GATEWAY_PORT% is in use, trying backup port 18790...
    set "GATEWAY_PORT=18790"
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

rem Generate access token (random 16-char hex)
for /f "tokens=*" %%t in ('"%NODE_EXE%" -e "console.log(require('crypto').randomBytes(8).toString('hex'))" 2^>^&1') do set ACCESS_TOKEN=%%t

rem Save token to file
echo !ACCESS_TOKEN! > "%OPENCLAW_HOME%\.token"

echo [OK]  Environment is ready

rem ============================================
rem [5/5] Start OpenClaw Gateway
rem ============================================
echo.
echo [5/5] Starting OpenClaw Gateway...
echo.

rem Build access URL with token
set "ACCESS_URL=http://localhost:%GATEWAY_PORT%/?token=!ACCESS_TOKEN!"

echo   ==========================================
echo   Access URL (with token):
echo   !ACCESS_URL!
echo   ==========================================
echo.
echo   Token: !ACCESS_TOKEN!
echo   Saved to: %OPENCLAW_HOME%\.token
echo.
echo   To stop: Run stop.bat or close this window
echo.
echo ==========================================
echo.

rem Auto-open browser after 3 seconds (in background)
start "" cmd /c "timeout /t 3 /nobreak >nul && start !ACCESS_URL!"

rem Start OpenClaw Gateway
"%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run --allow-unconfigured

rem === Exit handling ===
echo.
if errorlevel 1 (
    echo [ERROR] OpenClaw exited with an error
    echo.
    echo Common causes:
    echo   1. Port %GATEWAY_PORT% is in use
    echo   2. Antivirus blocking - add to whitelist
    echo.
) else (
    echo [INFO] OpenClaw stopped normally
)
echo.
pause
