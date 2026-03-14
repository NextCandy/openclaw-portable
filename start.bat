@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable

echo.
echo ========================================
echo    OpenClaw Portable v4.1.8
echo    Auto-detect and repair dependencies
echo ========================================
echo.

rem Get current script directory
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
echo [INFO] Script directory: %SCRIPT_DIR%
echo.

rem ============================================
rem STEP 1: Check Node.js
rem ============================================
set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "NPM_GLOBAL=%SCRIPT_DIR%\npm-global"

if exist "%NODE_EXE%" (
    "%NODE_EXE%" --version >nul 2>&1
    if not errorlevel 1 (
        for /f "tokens=*" %%v in ('"%NODE_EXE%" --version') do set NODE_VER=%%v
        echo [OK] Found bundled Node.js !NODE_VER!
        goto :check_openclaw
    )
)

echo [WARN] Bundled node\node.exe not found.
echo        Trying system Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No Node.js found. Please re-extract the portable package.
    pause
    exit /b 1
)
set "NODE_EXE=node"
echo [OK] Using system Node.js.

rem ============================================
rem STEP 2: Check OpenClaw (with auto-install)
rem ============================================
:check_openclaw

rem Find openclaw command
if exist "%NPM_GLOBAL%\openclaw.cmd" (
    set "OPENCLAW_CMD=%NPM_GLOBAL%\openclaw.cmd"
) else if exist "%NPM_GLOBAL%\bin\openclaw.cmd" (
    set "OPENCLAW_CMD=%NPM_GLOBAL%\bin\openclaw.cmd"
)

if not "%OPENCLAW_CMD%"=="" (
    echo [OK] Found OpenClaw at: %OPENCLAW_CMD%
    goto :verify_installation
)

rem ============================================
rem STEP 2.5: Auto-install OpenClaw (with retry)
rem ============================================
echo.
echo [WARN] OpenClaw not found. Starting auto-install...
echo.

set MAX_RETRIES=3
set RETRY_COUNT=0

:install_loop
set /a RETRY_COUNT+=1
echo [INSTALL] Attempting to install OpenClaw (!RETRY_COUNT!/%MAX_RETRIES%)...
echo.

rem Create npm-global directory
if not exist "%NPM_GLOBAL%" mkdir "%NPM_GLOBAL%"

rem Install OpenClaw
"%NODE_EXE%" "%SCRIPT_DIR%\node\node_modules\npm\bin\npm-cli.js" install openclaw@latest ^
    --no-git-tag-version ^
    --no-audit ^
    --no-fund ^
    --loglevel error ^
    --prefix "%SCRIPT_DIR%" ^
    --global-style

if errorlevel 1 (
    echo.
    echo [WARN] npm install failed (attempt !RETRY_COUNT!)
    
    if !RETRY_COUNT! LSS %MAX_RETRIES% (
        echo.
        echo [DIAGNOSE] Checking failure reason...
        
        rem Check network
        ping -n 1 registry.npmjs.org >nul 2>&1
        if errorlevel 1 (
            echo [!] Network issue detected
        ) else (
            echo [OK] Network OK
        )
        
        rem Clean npm cache
        echo [CLEAN] Clearing npm cache...
        "%NODE_EXE%" "%SCRIPT_DIR%\node\node_modules\npm\bin\npm-cli.js" cache clean --force >nul 2>&1
        
        echo.
        echo [RETRY] Retrying in 5 seconds...
        timeout /t 5 /nobreak >nul
        goto install_loop
    ) else (
        echo.
        echo [ERROR] Installation failed after %MAX_RETRIES% attempts
        echo.
        echo Possible fixes:
        echo   1. Check your internet connection
        echo   2. Run as Administrator
        echo   3. Disable antivirus temporarily
        echo   4. Try manual install: npm install openclaw -g
        pause
        exit /b 1
    )
)

rem Re-check for openclaw command after install
if exist "%NPM_GLOBAL%\openclaw.cmd" (
    set "OPENCLAW_CMD=%NPM_GLOBAL%\openclaw.cmd"
) else if exist "%NPM_GLOBAL%\bin\openclaw.cmd" (
    set "OPENCLAW_CMD=%NPM_GLOBAL%\bin\openclaw.cmd"
) else (
    echo [WARN] openclaw.cmd still not found after install, trying WSL2...
    goto :try_wsl
)

echo [OK] OpenClaw installed successfully!

rem ============================================
rem STEP 3: Verify installation
rem ============================================
:verify_installation

echo.
echo [VERIFY] Checking installation integrity...
set VERIFY_FAILED=0

rem Check 1: npm-global exists
if not exist "%NPM_GLOBAL%" (
    echo [X] npm-global directory not found
    set VERIFY_FAILED=1
) else (
    echo [OK] npm-global exists
)

rem Check 2: openclaw package
if exist "%SCRIPT_DIR%\node_modules\openclaw" (
    echo [OK] openclaw package exists
) else (
    echo [X] openclaw package not found
    set VERIFY_FAILED=1
)

rem Check 3: entry file
set ENTRY_FOUND=0
for %%p in (
    "%SCRIPT_DIR%\node_modules\openclaw\dist\entry.js"
    "%SCRIPT_DIR%\node_modules\openclaw\lib\entry.js"
    "%SCRIPT_DIR%\node_modules\openclaw\src\entry.js"
    "%SCRIPT_DIR%\node_modules\openclaw\entry.js"
    "%SCRIPT_DIR%\node_modules\openclaw\index.js"
) do (
    if exist %%p (
        echo [OK] Entry file found
        set ENTRY_FOUND=1
    )
)

if !ENTRY_FOUND! EQU 0 (
    echo [X] Entry file not found
    set VERIFY_FAILED=1
)

if !VERIFY_FAILED! EQU 1 (
    echo.
    echo [WARN] Verification failed, reinstalling...
    rmdir /s /q "%SCRIPT_DIR%\node_modules" 2>nul
    rmdir /s /q "%NPM_GLOBAL%" 2>nul
    
    if !RETRY_COUNT! LSS %MAX_RETRIES% (
        goto install_loop
    ) else (
        echo [ERROR] Max retries reached. Please re-download the package.
        pause
        exit /b 1
    )
)

echo [OK] All checks passed!
echo.

rem ============================================
rem STEP 4: Start OpenClaw (native Windows)
rem ============================================
:start_native

echo.
echo [START] Launching OpenClaw via native Windows Node.js...
echo.

set "PATH=%SCRIPT_DIR%\node;%SCRIPT_DIR%\node\bin;%NPM_GLOBAL%;%NPM_GLOBAL%\bin;%PATH%"
set "OPENCLAW_WORKSPACE=%SCRIPT_DIR%\workspace"
set "OPENCLAW_CONFIG_DIR=%SCRIPT_DIR%\config"
set "NODE_PATH=%NPM_GLOBAL%\lib\node_modules"

if not exist "%SCRIPT_DIR%\workspace" mkdir "%SCRIPT_DIR%\workspace"
if not exist "%SCRIPT_DIR%\config" mkdir "%SCRIPT_DIR%\config"
if not exist "%SCRIPT_DIR%\data" mkdir "%SCRIPT_DIR%\data"

echo [RUN] Starting OpenClaw Gateway...
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

rem ============================================
rem WSL2 fallback path
rem ============================================
:try_wsl

echo.
echo [INFO] Checking WSL2 availability...

wsl --status >nul 2>&1
if not errorlevel 1 (
    echo [OK] WSL2 is available.
    goto :start_wsl
)

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
net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Admin rights required to install WSL2.
    echo         Right-click start.bat and choose "Run as administrator".
    pause
    exit /b 1
)

echo [INFO] Enabling WSL2 features...
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart >nul 2>&1
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart >nul 2>&1

echo [INFO] Installing WSL2 with Ubuntu...
wsl --install -d Ubuntu
if errorlevel 1 (
    echo.
    echo [ERROR] WSL2 install failed.
    echo         Please run manually as admin: wsl --install -d Ubuntu
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
