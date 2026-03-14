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

rem OpenClaw entry file
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

echo [OK]  Environment is ready

rem ============================================
rem [5/5] Start OpenClaw Gateway
rem ============================================
echo.
echo [5/5] Starting OpenClaw Gateway...
echo.
echo   Gateway is starting...
echo   Waiting for token generation...
echo.

rem Start OpenClaw Gateway in background and capture output
start /b "" "%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run --allow-unconfigured

rem Wait for gateway to start and generate token (max 10 seconds)
set TOKEN_FILE=%OPENCLAW_HOME%\.token
set TOKEN_WAIT=0

:wait_for_token
if exist "%TOKEN_FILE%" goto :got_token
timeout /t 1 /nobreak >nul
set /a TOKEN_WAIT+=1
if !TOKEN_WAIT! geq 10 goto :timeout
goto :wait_for_token

:got_token
rem Read token from file
set /p ACCESS_TOKEN=<"%TOKEN_FILE%"

echo   ==========================================
echo   Access URL (with token):
echo   http://localhost:%GATEWAY_PORT%/?token=!ACCESS_TOKEN!
echo   ==========================================
echo.
echo   Token: !ACCESS_TOKEN!
echo   Saved to: %TOKEN_FILE%
echo.
echo   To stop: Run stop.bat or close this window
echo.
echo ==========================================
echo.

rem Auto-open browser
start http://localhost:%GATEWAY_PORT%/?token=!ACCESS_TOKEN!

rem Keep window open
echo Gateway is running. Close this window to stop.
echo.
pause
goto :eof

:timeout
echo.
echo [WARN] Timeout waiting for token
echo        Gateway may still be starting...
echo.
echo   Access URL: http://localhost:%GATEWAY_PORT%
echo   Token file: %TOKEN_FILE%
echo.
pause
