@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable

echo.
echo ==========================================
echo   OpenClaw Portable - Windows Launcher
echo ==========================================
echo.

rem ============================================
rem STEP 0: Resolve script directory
rem ============================================
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "NODE_DIR=%SCRIPT_DIR%\node"
set "NODE_EXE=%NODE_DIR%\node.exe"
set "NPM_CLI=%NODE_DIR%\node_modules\npm\bin\npm-cli.js"
set "PKG_DIR=%SCRIPT_DIR%\openclaw-pkg"
set "OPENCLAW_ENTRY=%PKG_DIR%\lib\node_modules\openclaw\bin\openclaw"

echo [INFO] Base directory: %SCRIPT_DIR%
echo.

rem ============================================
rem STEP 1: Check bundled Node.js
rem         If missing, auto-download it
rem ============================================
echo [1/4] Checking Node.js...

if exist "%NODE_EXE%" (
    for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
    echo [OK]  Bundled Node.js !NODE_VER!
    goto :check_openclaw
)

echo [WARN] node\node.exe not found. Will download Node.js now.
echo       This only happens ONCE. All future runs are fully offline.
echo.

rem Use PowerShell to download - available on all Windows 10/11
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference='Stop'; ^
    $nodeVer='22.14.0'; ^
    $dir='%SCRIPT_DIR%'; ^
    $mirrors=@('https://npmmirror.com/mirrors/node/v'+$nodeVer+'/node-v'+$nodeVer+'-win-x64.zip','https://nodejs.org/dist/v'+$nodeVer+'/node-v'+$nodeVer+'-win-x64.zip'); ^
    $zip=$dir+'\\node.zip'; ^
    $tmp=$dir+'\\node_tmp'; ^
    $ok=$false; ^
    foreach($url in $mirrors){ ^
        try{ ^
            Write-Host ('[INFO] Downloading from: '+$url); ^
            (New-Object Net.WebClient).DownloadFile($url,$zip); ^
            $ok=$true; break ^
        }catch{ Write-Host ('[WARN] Mirror failed, trying next...') } ^
    }; ^
    if(-not $ok){Write-Error 'All mirrors failed'; exit 1}; ^
    Write-Host '[INFO] Extracting...'; ^
    if(Test-Path $tmp){Remove-Item $tmp -Recurse -Force}; ^
    Expand-Archive -Path $zip -DestinationPath $tmp -Force; ^
    $sub=Get-ChildItem $tmp -Directory | Select-Object -First 1; ^
    if(Test-Path ($dir+'\\node')){Remove-Item ($dir+'\\node') -Recurse -Force}; ^
    Move-Item $sub.FullName ($dir+'\\node'); ^
    Remove-Item $zip,$tmp -Recurse -Force -ErrorAction SilentlyContinue; ^
    Write-Host '[OK]  Node.js ready.'"

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to download Node.js.
    echo         Please check your internet connection and try again.
    echo         Or manually place Node.js 22.x Windows x64 portable into: node\
    echo         Download from: https://nodejs.org/dist/v22.14.0/node-v22.14.0-win-x64.zip
    pause
    exit /b 1
)

if not exist "%NODE_EXE%" (
    echo [ERROR] Download completed but node.exe not found. Unexpected error.
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
echo [OK]  Node.js %NODE_VER% downloaded and ready.

:check_openclaw
rem ============================================
rem STEP 2: Check OpenClaw installation
rem         If missing, install via bundled npm
rem ============================================
echo.
echo [2/4] Checking OpenClaw...

if exist "%OPENCLAW_ENTRY%" (
    echo [OK]  OpenClaw found.
    goto :setup_env
)

echo [INFO] OpenClaw not found. Installing now (requires internet, one-time only)...
echo.

if not exist "%NPM_CLI%" (
    echo [ERROR] npm not found at: %NPM_CLI%
    echo         The Node.js package may be incomplete. Delete node\ and re-run to re-download.
    pause
    exit /b 1
)

if not exist "%PKG_DIR%" mkdir "%PKG_DIR%"

rem Try China mirror first, fall back to global npm registry
set INSTALL_OK=0
for %%R in (https://registry.npmmirror.com https://registry.npmjs.org) do (
    if !INSTALL_OK!==0 (
        echo [INFO] Trying registry: %%R
        "%NODE_EXE%" "%NPM_CLI%" install -g openclaw --prefix "%PKG_DIR%" --registry %%R
        if not errorlevel 1 set INSTALL_OK=1
    )
)

if %INSTALL_OK%==0 (
    echo.
    echo [ERROR] Failed to install OpenClaw from all registries.
    echo         Check your internet connection and try again.
    pause
    exit /b 1
)

if not exist "%OPENCLAW_ENTRY%" (
    echo [ERROR] Install reported success but openclaw entry not found.
    echo         Expected: %OPENCLAW_ENTRY%
    echo         Please open an issue at: https://github.com/SonicBotMan/openclaw-portable
    pause
    exit /b 1
)

echo [OK]  OpenClaw installed successfully.

:setup_env
rem ============================================
rem STEP 3: Set up environment
rem ============================================
echo.
echo [3/4] Setting up environment...

set "PATH=%NODE_DIR%;%NODE_DIR%\bin;%PKG_DIR%\bin;%PATH%"
set "OPENCLAW_WORKSPACE=%SCRIPT_DIR%\workspace"
set "OPENCLAW_CONFIG_DIR=%SCRIPT_DIR%\config"
set "NODE_PATH=%PKG_DIR%\lib\node_modules"

if not exist "%SCRIPT_DIR%\workspace" mkdir "%SCRIPT_DIR%\workspace"
if not exist "%SCRIPT_DIR%\config"    mkdir "%SCRIPT_DIR%\config"
if not exist "%SCRIPT_DIR%\data"      mkdir "%SCRIPT_DIR%\data"

echo [OK]  Directories ready.

rem ============================================
rem STEP 4: Start OpenClaw
rem ============================================
echo.
echo [4/4] Starting OpenClaw Gateway...
echo.

"%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway start

if errorlevel 1 (
    echo.
    echo [ERROR] OpenClaw failed to start!
    echo.
    echo  Possible causes:
    echo    1. Port 3000 is already in use
    echo       Run: netstat -aon | findstr :3000
    echo    2. OpenClaw installation is corrupted
    echo       Delete openclaw-pkg\ folder and re-run start.bat
    echo    3. Config file error
    echo       Check: %SCRIPT_DIR%\config\
    echo.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   SUCCESS  OpenClaw is running!
echo   Visit:   http://localhost:3000
echo   Stop:    Run stop.bat to shut down
echo ==========================================
echo.
pause
