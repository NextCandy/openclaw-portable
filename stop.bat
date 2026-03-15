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
set "LLM_PORT=18080"

rem ============================================
rem [1/5] Stop Gateway process
rem ============================================
echo [1/5] Stopping Gateway...

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

echo [OK]  Gateway process stopped

rem ============================================
rem [NEW 2/5] Stop bundled llama-server
rem ============================================
echo.
echo [2/5] Stopping bundled local model...

rem Method 1: Kill process on LLM port
for /f "tokens=5" %%a in ('netstat -aon 2^>^nul ^| findstr ":%LLM_PORT%" ^| findstr "LISTENING"') do (
    echo [INFO] Killing llama-server PID %%a
    taskkill /F /PID %%a >nul 2>&1
)

rem Method 2: Check PID file
if exist "%SCRIPT_DIR%\llm\server.pid" (
    for /f "tokens=1" %%i in (%SCRIPT_DIR%\llm\server.pid) do (
        taskkill /F /PID %%i >nul 2>&1
        echo [OK]  llama-server stopped (PID: %%i)
    )
    del /f /q "%SCRIPT_DIR%\llm\server.pid" 2>nul
) else (
    echo [INFO] No llama-server PID file found
)

echo [OK]  Bundled model stopped

rem ============================================
rem [3/5] Cleanup temp files
rem ============================================
echo.
echo [3/5] Cleaning temp files...

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
rem [4/5] Verify cleanup
rem ============================================
echo.
echo [4/5] Verifying...

rem Check if Gateway port is released
netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [OK]  Gateway port %GATEWAY_PORT% is released
) else (
    echo [WARN] Gateway port %GATEWAY_PORT% is still in use
    echo        You may need to kill the process manually
)

rem Check if LLM port is released
netstat -aon 2>nul | findstr ":%LLM_PORT%" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [OK]  Model port %LLM_PORT% is released
) else (
    echo [WARN] Model port %LLM_PORT% is still in use
)

rem ============================================
rem [5/5] Summary
rem ============================================
echo.
echo [5/5] Summary
echo.
echo ==========================================
echo   OpenClaw stopped completely
echo ==========================================
echo.
echo   Stopped:
echo   - Gateway process (port %GATEWAY_PORT%)
echo   - Bundled model (port %LLM_PORT%)
echo.
echo   Cleaned:
echo   - temp\ directory
echo   - npm cache
echo   - System temp files
echo.
echo   Preserved:
echo   - data\ (config and data)
echo   - workspace\ (workspace)
echo   - config\ (config files)
echo   - llm\models\ (model files)
echo.
pause
