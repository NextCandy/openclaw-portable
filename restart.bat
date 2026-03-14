@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable - Restart Gateway

echo.
echo ==========================================
echo   OpenClaw Portable - Restart Gateway
echo ==========================================
echo.

rem === Resolve script directory ===
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "OPENCLAW_ENTRY_LINUX=%SCRIPT_DIR%\openclaw-pkg\lib\node_modules\openclaw\openclaw.mjs"
set "OPENCLAW_ENTRY_WINDOWS=%SCRIPT_DIR%\openclaw-pkg\node_modules\openclaw\openclaw.mjs"

if exist "%OPENCLAW_ENTRY_LINUX%" (
    set "OPENCLAW_ENTRY=%OPENCLAW_ENTRY_LINUX%"
) else if exist "%OPENCLAW_ENTRY_WINDOWS%" (
    set "OPENCLAW_ENTRY=%OPENCLAW_ENTRY_WINDOWS%"
) else (
    set "OPENCLAW_ENTRY=%OPENCLAW_ENTRY_LINUX%"
)

echo [1/3] Stopping Gateway...
taskkill /F /IM node.exe 2>nul
timeout /t 2 /nobreak >nul
echo [OK] Gateway stopped

echo.
echo [2/3] Checking configuration...
set "CONFIG_FILE=%SCRIPT_DIR%\data\.openclaw\openclaw.json"
if exist "%CONFIG_FILE%" (
    echo [OK] Configuration file found
) else (
    echo [WARN] Configuration file not found: %CONFIG_FILE%
    echo       Using default settings
)

echo.
echo [3/3] Starting Gateway...
echo.
echo   Access URL: http://localhost:18789
echo.
echo ==========================================
echo.

start "" cmd /c "timeout /t 8 /nobreak >nul && start http://localhost:18789"

"%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run --allow-unconfigured

echo.
if errorlevel 1 (
    echo [ERROR] Gateway exited with an error
) else (
    echo [INFO] Gateway stopped normally
)
echo.
pause
