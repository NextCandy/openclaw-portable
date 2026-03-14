@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable - Stop

echo.
echo ==========================================
echo   OpenClaw Portable - Stop Service
echo ==========================================
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "GATEWAY_PORT=18789"

rem ============================================
rem [1/3] Stop Gateway process
rem ============================================
echo [1/3] Stopping Gateway...

rem Method 1: Graceful stop via API
curl -fsSL "http://localhost:%GATEWAY_PORT%/api/gateway/stop" 2>nul
if not errorlevel 1 (
    echo [OK]  Gateway stopped via API
    timeout /t 2 /nobreak >nul
)

rem Method 2: Force kill process on port
for /f "tokens=5" %%a in ('netstat -aon 2^>^nul ^| findstr ":%GATEWAY_PORT%" ^| findstr "LISTENING"') do (
    echo [INFO] Killing process PID %%a
    taskkill /F /PID %%a >nul 2>&1
)

echo [OK]  Process stopped

rem ============================================
rem [2/3] Cleanup temp files
rem ============================================
echo.
echo [2/3] Cleaning temp files...

rem Clean temp directory
if exist "%SCRIPT_DIR%\temp" (
    rd /s /q "%SCRIPT_DIR%\temp" 2>nul
    mkdir "%SCRIPT_DIR%\temp"
    echo [OK]  temp\ cleaned
)

rem Clean npm cache (optional)
if exist "%SCRIPT_DIR%\node\npm-cache" (
    rd /s /q "%SCRIPT_DIR%\node\npm-cache" 2>nul
    echo [OK]  npm-cache cleaned
)

rem Clean system temp files (OpenClaw related only)
for %%f in ("%TEMP%\openclaw-*" "%TEMP%\node-*") do (
    if exist "%%f" del /f /q "%%f" 2>nul
)
echo [OK]  System temp files cleaned

rem ============================================
rem [3/3] Verify cleanup
rem ============================================
echo.
echo [3/3] Verifying...

rem Check if port is released
netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [OK]  Port %GATEWAY_PORT% is released
) else (
    echo [WARN] Port %GATEWAY_PORT% is still in use
    echo        You may need to kill the process manually
)

echo.
echo ==========================================
echo   OpenClaw stopped completely
echo ==========================================
echo.
echo   Cleaned:
echo   - Gateway process
echo   - temp\ directory
echo   - npm cache
echo   - System temp files
echo.
echo   Preserved:
echo   - data\ (config and data)
echo   - workspace\ (workspace)
echo   - config\ (config files)
echo.
pause
