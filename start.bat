@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable

echo.
echo ==========================================
echo   OpenClaw Portable - Windows Launcher
echo ==========================================
echo.

rem ============================================
rem STEP 0: Resolve script directory (no trailing backslash)
rem ============================================
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

rem --- Paths ---
set "NODE_DIR=%SCRIPT_DIR%\node"
set "NODE_EXE=%NODE_DIR%\node.exe"
rem npm-cli.js lives inside Node.js portable zip at node_modules\npm\bin\npm-cli.js
set "NPM_CLI=%NODE_DIR%\node_modules\npm\bin\npm-cli.js"

rem PKG_DIR = where we install openclaw globally via --prefix
rem IMPORTANT: On Windows, npm global --prefix puts packages at {prefix}\node_modules (NO lib\ layer)
set "PKG_DIR=%SCRIPT_DIR%\openclaw-pkg"
set "OPENCLAW_ENTRY=%PKG_DIR%\node_modules\openclaw\bin\openclaw"

rem OPENCLAW_HOME = portable data directory (overrides default %USERPROFILE%\.openclaw)
set "OPENCLAW_HOME=%SCRIPT_DIR%\data"

rem Gateway port (openclaw default is 18789, NOT 3000)
set "GATEWAY_PORT=18789"

echo [INFO] Script dir : %SCRIPT_DIR%
echo [INFO] Node dir   : %NODE_DIR%
echo [INFO] PKG dir    : %PKG_DIR%
echo [INFO] Data home  : %OPENCLAW_HOME%
echo.

rem ============================================
rem STEP 1: Ensure Node.js 22.16+ is present
rem         Auto-download if missing
rem ============================================
echo [1/4] Checking Node.js...

if exist "%NODE_EXE%" (
    for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
    echo [OK]  Node.js !NODE_VER! found.
    goto :check_openclaw
)

echo [WARN] node\node.exe not found.
echo [INFO] Downloading Node.js 22.16.0 (one-time, ~30 MB)...
echo [INFO] Trying China mirror first, then nodejs.org fallback.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference = 'Stop';" ^
  "$ver = '22.16.0';" ^
  "$base = '%SCRIPT_DIR%';" ^
  "$zip  = $base + '\\node.zip';" ^
  "$tmp  = $base + '\\node_tmp';" ^
  "$mirrors = @(" ^
  "  'https://npmmirror.com/mirrors/node/v' + $ver + '/node-v' + $ver + '-win-x64.zip'," ^
  "  'https://nodejs.org/dist/v'            + $ver + '/node-v' + $ver + '-win-x64.zip'" ^
  ");" ^
  "$ok = $false;" ^
  "foreach ($url in $mirrors) {" ^
  "  try {" ^
  "    Write-Host ( '[INFO] GET ' + $url );" ^
  "    (New-Object Net.WebClient).DownloadFile($url, $zip);" ^
  "    $ok = $true; break" ^
  "  } catch { Write-Host '[WARN] Mirror failed, trying next...' }" ^
  "};" ^
  "if (-not $ok) { Write-Error 'All mirrors failed.'; exit 1 };" ^
  "Write-Host '[INFO] Extracting...';" ^
  "if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force };" ^
  "Expand-Archive -Path $zip -DestinationPath $tmp -Force;" ^
  "$sub = Get-ChildItem $tmp -Directory | Select-Object -First 1;" ^
  "if (Test-Path ($base + '\\node')) { Remove-Item ($base + '\\node') -Recurse -Force };" ^
  "Move-Item $sub.FullName ($base + '\\node');" ^
  "Remove-Item $zip -Force -ErrorAction SilentlyContinue;" ^
  "Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue;" ^
  "Write-Host '[OK]  Node.js ready.'"

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to download Node.js.
    echo         Check your network, then try again.
    echo         Manual: download node-v22.16.0-win-x64.zip from nodejs.org
    echo                 extract it and rename the folder to: node\
    pause
    exit /b 1
)

if not exist "%NODE_EXE%" (
    echo [ERROR] Extraction finished but node.exe not found. Zip may be corrupt.
    echo         Delete node.zip and node_tmp\ then re-run.
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
echo [OK]  Node.js %NODE_VER% ready.

:check_openclaw
rem ============================================
rem STEP 2: Ensure OpenClaw is installed
rem         One-time install via npm, then fully offline
rem ============================================
echo.
echo [2/4] Checking OpenClaw...

if exist "%OPENCLAW_ENTRY%" (
    echo [OK]  OpenClaw found.
    goto :setup_env
)

echo [INFO] OpenClaw not installed yet. Installing (one-time, ~30 MB)...
echo [INFO] Trying China registry first, then npmjs.org fallback.
echo.

if not exist "%NPM_CLI%" (
    echo [ERROR] npm not found at expected path:
    echo         %NPM_CLI%
    echo         The Node.js download may be incomplete.
    echo         Delete node\ folder and re-run start.bat to re-download.
    pause
    exit /b 1
)

if not exist "%PKG_DIR%" mkdir "%PKG_DIR%"

set "INSTALL_OK=0"

echo [INFO] Trying registry: https://registry.npmmirror.com
"%NODE_EXE%" "%NPM_CLI%" install -g openclaw --prefix "%PKG_DIR%" --registry https://registry.npmmirror.com
if not errorlevel 1 (
    set "INSTALL_OK=1"
    goto :verify_install
)

echo [WARN] China registry failed. Trying: https://registry.npmjs.org
"%NODE_EXE%" "%NPM_CLI%" install -g openclaw --prefix "%PKG_DIR%" --registry https://registry.npmjs.org
if not errorlevel 1 (
    set "INSTALL_OK=1"
    goto :verify_install
)

:verify_install
if "%INSTALL_OK%"=="0" (
    echo.
    echo [ERROR] Failed to install OpenClaw from all registries.
    echo         Check your internet connection and try again.
    pause
    exit /b 1
)

if not exist "%OPENCLAW_ENTRY%" (
    echo.
    echo [ERROR] npm install succeeded but entry file not found.
    echo         Expected path: %OPENCLAW_ENTRY%
    echo.
    echo  Checking what was actually installed:
    dir "%PKG_DIR%\node_modules\" /b 2^>nul
    echo.
    echo  If you see openclaw listed above, the bin path may have changed.
    echo  Please report this at: https://github.com/SonicBotMan/openclaw-portable/issues
    pause
    exit /b 1
)

echo [OK]  OpenClaw installed.

:setup_env
rem ============================================
rem STEP 3: Setup environment
rem ============================================
echo.
echo [3/4] Setting up environment...

rem Prepend our node.exe so it shadows any system Node
set "PATH=%NODE_DIR%;%PKG_DIR%\node_modules\.bin;%PATH%"

rem Point openclaw at our portable data directory instead of %USERPROFILE%\.openclaw
set "OPENCLAW_HOME=%SCRIPT_DIR%\data"

rem Create required directories
if not exist "%SCRIPT_DIR%\data"      mkdir "%SCRIPT_DIR%\data"
if not exist "%SCRIPT_DIR%\workspace" mkdir "%SCRIPT_DIR%\workspace"

rem Write minimal openclaw.json if it does not exist yet
if not exist "%OPENCLAW_HOME%\openclaw.json" (
    echo [INFO] Creating default openclaw.json in %OPENCLAW_HOME%
    (
        echo {^
        echo   "gateway": {^
        echo     "mode": "local"^
        echo   }^
        echo }
    ) > "%OPENCLAW_HOME%\openclaw.json"
)

echo [OK]  Environment ready.
echo.

rem ============================================
rem STEP 4: Run OpenClaw Gateway (FOREGROUND)
rem
rem  IMPORTANT NOTES:
rem  - Use "gateway run", NOT "gateway start"
rem    gateway start = manage a system service (launchd/schtasks)
rem    gateway run   = foreground process (correct for portable use)
rem  - This window will stay open showing gateway logs.
rem    DO NOT close this window while using OpenClaw.
rem    Use stop.bat to shut down cleanly.
rem  - Default gateway port is 18789 (NOT 3000)
rem ============================================
echo [4/4] Starting OpenClaw Gateway (foreground)...
echo.
echo   Access at: http://localhost:%GATEWAY_PORT%
echo   To stop:   close this window or run stop.bat
echo.
echo ==========================================
echo.

"%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run

rem --- Only reaches here if gateway exits (error or user stop) ---
echo.
if errorlevel 1 (
    echo [ERROR] OpenClaw gateway exited with an error.
    echo.
    echo  Common causes:
    echo    1. Port %GATEWAY_PORT% already in use
    echo       Check: netstat -aon | findstr :%GATEWAY_PORT%
    echo    2. openclaw-pkg\ is corrupted - delete it and re-run
    echo    3. See error output above for details
    echo.
) else (
    echo [INFO] OpenClaw gateway stopped normally.
)
echo.
pause
