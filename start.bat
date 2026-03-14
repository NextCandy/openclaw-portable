@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable

echo.
echo ========================================
echo    OpenClaw Portable - Windows Launcher
echo ========================================
echo.

rem Get current script directory
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
echo [INFO] Script directory: %SCRIPT_DIR%
echo.

rem ============================================
rem STEP 1: Try native Windows launch (no WSL2 needed)
rem ============================================
set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "NPM_GLOBAL=%SCRIPT_DIR%\npm-global"
set "OPENCLAW_CMD="

if exist "%NODE_EXE%" (
    "%NODE_EXE%" --version >nul 2>&1
    if not errorlevel 1 (
        for /f "tokens=*" %%v in ('"%NODE_EXE%" --version') do set NODE_VER=%%v
        echo [OK] Found bundled Node.js !NODE_VER!
        goto :check_openclaw
    )
)

echo [WARN] Bundled node\node.exe not found or not executable.
echo        Trying system Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No Node.js found. Please re-extract the portable package.
    pause
    exit /b 1
)
set "NODE_EXE=node"
echo [OK] Using system Node.js.

:check_openclaw
rem Find openclaw command
if exist "%NPM_GLOBAL%\openclaw.cmd" (
    set "OPENCLAW_CMD=%NPM_GLOBAL%\openclaw.cmd"
) else if exist "%NPM_GLOBAL%\bin\openclaw.cmd" (
    set "OPENCLAW_CMD=%NPM_GLOBAL%\bin\openclaw.cmd"
)

if not "%OPENCLAW_CMD%"=="" (
    echo [OK] Found OpenClaw at: %OPENCLAW_CMD%
    goto :start_native
)

echo [WARN] openclaw.cmd not found in npm-global. Falling back to WSL2 mode...
goto :try_wsl

:start_native
rem ============================================
rem Native Windows launch (recommended path)
rem ============================================
echo.
echo [INFO] Launching via native Windows Node.js (no WSL2 required)
echo.

set "PATH=%SCRIPT_DIR%\node;%SCRIPT_DIR%\node\bin;%NPM_GLOBAL%;%NPM_GLOBAL%\bin;%PATH%"
set "OPENCLAW_WORKSPACE=%SCRIPT_DIR%\workspace"
set "OPENCLAW_CONFIG_DIR=%SCRIPT_DIR%\config"
set "NODE_PATH=%NPM_GLOBAL%\lib\node_modules"

if not exist "%SCRIPT_DIR%\workspace" mkdir "%SCRIPT_DIR%\workspace"
if not exist "%SCRIPT_DIR%\config" mkdir "%SCRIPT_DIR%\config"
if not exist "%SCRIPT_DIR%\data" mkdir "%SCRIPT_DIR%\data"

echo [START] Starting OpenClaw Gateway...
echo.
call "%OPENCLAW_CMD%" gateway start
if errorlevel 1 (
    echo.
    echo [ERROR] Failed to start OpenClaw!
    echo         Check if port 3000 is already in use.
    pause
    exit /b 1
)
goto :success

:try_wsl
rem ============================================
rem WSL2 fallback path
rem ============================================
echo.
echo [INFO] Checking WSL2 availability...

wsl --status >nul 2>&1
if not errorlevel 1 (
    echo [OK] WSL2 is available.
    goto :start_wsl
)

rem WSL2 not installed - check if we can install it
echo [WARN] WSL2 is not installed.
echo.
echo WSL2 is required as a fallback. Options:
echo   [1] Auto-install WSL2 (requires admin rights + reboot)
echo   [2] Exit and re-extract the portable package
echo.
set /p WSL_CHOICE="Enter choice (1 or 2): "

if "%WSL_CHOICE%"=="1" goto :install_wsl
echo Exiting. Please re-extract and ensure node\ directory is present.
pause
exit /b 1

:install_wsl
rem Check admin privileges
net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Admin rights required to install WSL2.
    echo         Right-click start.bat and choose "Run as administrator".
    pause
    exit /b 1
)

echo [INFO] Enabling WSL2 features (this may take a few minutes)...
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart >nul 2>&1
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart >nul 2>&1

echo [INFO] Installing WSL2 with Ubuntu...
wsl --install -d Ubuntu
if errorlevel 1 (
    echo.
    echo [ERROR] WSL2 install failed.
    echo         Please run manually as admin:  wsl --install -d Ubuntu
    echo         Then reboot and re-run start.bat
    pause
    exit /b 1
)

echo.
echo [DONE] WSL2 installed. A REBOOT IS REQUIRED.
echo        After reboot, run start.bat again.
echo.
pause
exit /b 0

:start_wsl
rem ============================================
rem Launch via WSL2
rem ============================================
rem Convert Windows path to WSL path
set "DRIVE_LETTER=%SCRIPT_DIR:~0,1%"
set "SCRIPT_PATH=%SCRIPT_DIR:~2%"
set "SCRIPT_PATH=%SCRIPT_PATH:\=/%"
set "WSL_PATH=/mnt/%DRIVE_LETTER%%SCRIPT_PATH%"

echo [INFO] WSL path: %WSL_PATH%
echo [START] Starting OpenClaw via WSL2...
echo.

wsl -e bash -c "cd '%WSL_PATH%' && chmod +x *.sh && ./start.sh '%WSL_PATH%'"
if errorlevel 1 (
    echo.
    echo [ERROR] WSL2 launch failed. Check the error above.
    pause
    exit /b 1
)

:success
echo.
echo ========================================
echo   SUCCESS - OpenClaw is running!
echo   Visit: http://localhost:3000
echo ========================================
echo.
echo Run stop.bat to shut down cleanly.
echo.
pause
