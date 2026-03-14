@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable

echo.
echo ==========================================
echo   OpenClaw Portable - Windows Launcher
echo ==========================================
echo.

rem === Resolve script directory (no trailing backslash) ===
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "NODE_DIR=%SCRIPT_DIR%\node"
set "NODE_EXE=%NODE_DIR%\node.exe"
set "NPM_CLI=%NODE_DIR%\node_modules\npm\bin\npm-cli.js"
set "PKG_DIR=%SCRIPT_DIR%\openclaw-pkg"
rem On Windows, npm global --prefix puts packages at {prefix}\node_modules (NO lib\ layer)
set "OPENCLAW_ENTRY=%PKG_DIR%\node_modules\openclaw\bin\openclaw"
set "OPENCLAW_HOME=%SCRIPT_DIR%\data"
set "GATEWAY_PORT=18789"

echo [INFO] Script dir : %SCRIPT_DIR%
echo [INFO] Node dir   : %NODE_DIR%
echo [INFO] PKG dir    : %PKG_DIR%
echo [INFO] Data home  : %OPENCLAW_HOME%
echo.

rem ============================================
rem STEP 1: Ensure Node.js 22.16+ is present
rem ============================================
echo [1/4] Checking Node.js...

if exist "%NODE_EXE%" (
    for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
    echo [OK]  Node.js !NODE_VER! found.
    goto :check_openclaw
)

echo [WARN] node\node.exe not found.
echo [INFO] Downloading Node.js 22.16.0 - one time only, ~30 MB...
echo.

rem ----------------------------------------------------------------
rem  PowerShell download script encoded as Base64 UTF-16LE.
rem  Compatible with PowerShell 3.0+ (including Windows 10 PS 5.1).
rem  SCRIPT_DIR is passed via environment variable OPENCLAW_SCRIPT_DIR
rem  to avoid using -Args which is PowerShell 7+ only.
rem  To regenerate Base64:
rem    python3 -c "import base64; s=open('dl_node.ps1').read();
rem      print(base64.b64encode(s.encode('utf-16-le')).decode())"
rem ----------------------------------------------------------------
set "OPENCLAW_SCRIPT_DIR=%SCRIPT_DIR%"
set B64=JABFAHIAcgBvAHIAQQBjAHQAaQBvAG4AUAByAGUAZgBlAHIAZQBuAGMAZQAgAD0AIAAnAFMAdABvAHAAJwAKACQAdgBlAHIAIAAgAD0AIAAnADIAMgAuADEANgAuADAAJwAKACQAYgBhAHMAZQAgAD0AIAAkAGUAbgB2ADoATwBQAEUATgBDAEwAQQBXAF8AUwBDAFIASQBQAFQAXwBEAEkAUgAKACQAegBpAHAAIAAgAD0AIABKAG8AaQBuAC0AUABhAHQAaAAgACQAYgBhAHMAZQAgACcAbgBvAGQAZQAuAHoAaQBwACcACgAkAHQAbQBwACAAIAA9ACAASgBvAGkAbgAtAFAAYQB0AGgAIAAkAGIAYQBzAGUAIAAnAG4AbwBkAGUAXwB0AG0AcAAnAAoAJABtAGkAcgByAG8AcgBzACAAPQAgAEAAKAAKACAAIAAgACAAIgBoAHQAdABwAHMAOgAvAC8AbgBwAG0AbQBpAHIAcgBvAHIALgBjAG8AbQAvAG0AaQByAHIAbwByAHMALwBuAG8AZABlAC8AdgAkAHYAZQByAC8AbgBvAGQAZQAtAHYAJAB2AGUAcgAtAHcAaQBuAC0AeAA2ADQALgB6AGkAcAAiACwACgAgACAAIAAgACIAaAB0AHQAcABzADoALwAvAG4AbwBkAGUAagBzAC4AbwByAGcALwBkAGkAcwB0AC8AdgAkAHYAZQByAC8AbgBvAGQAZQAtAHYAJAB2AGUAcgAtAHcAaQBuAC0AeAA2ADQALgB6AGkAcAAiAAoAKQAKACQAbwBrACAAPQAgACQAZgBhAGwAcwBlAAoAZgBvAHIAZQBhAGMAaAAgACgAJAB1AHIAbAAgAGkAbgAgACQAbQBpAHIAcgBvAHIAcwApACAAewAKACAAIAAgACAAdAByAHkAIAB7AAoAIAAgACAAIAAgACAAIAAgAFcAcgBpAHQAZQAtAEgAbwBzAHQAIAAiAFsASQBOAEYATwBdACAARABvAHcAbgBsAG8AYQBkAGkAbgBnACAAZgByAG8AbQA6ACAAJAB1AHIAbAAiAAoAIAAgACAAIAAgACAAIAAgACQAdwBjACAAPQAgAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0AAoAIAAgACAAIAAgACAAIAAgACQAdwBjAC4ARABvAHcAbgBsAG8AYQBkAEYAaQBsAGUAKAAkAHUAcgBsACwAIAAkAHoAaQBwACkACgAgACAAIAAgACAAIAAgACAAJABvAGsAIAA9ACAAJAB0AHIAdQBlAAoAIAAgACAAIAAgACAAIAAgAGIAcgBlAGEAawAKACAAIAAgACAAfQAgAGMAYQB0AGMAaAAgAHsACgAgACAAIAAgACAAIAAgACAAVwByAGkAdABlAC0ASABvAHMAdAAgACIAWwBXAEEAUgBOAF0AIABNAGkAcgByAG8AcgAgAGYAYQBpAGwAZQBkADoAIAAkAF8AIgAKACAAIAAgACAAfQAKAH0ACgBpAGYAIAAoAC0AbgBvAHQAIAAkAG8AawApACAAewAKACAAIAAgACAAVwByAGkAdABlAC0ARQByAHIAbwByACAAIgBBAGwAbAAgAG0AaQByAHIAbwByAHMAIABmAGEAaQBsAGUAZAAuACIACgAgACAAIAAgAGUAeABpAHQAIAAxAAoAfQAKAFcAcgBpAHQAZQAtAEgAbwBzAHQAIAAiAFsASQBOAEYATwBdACAARQB4AHQAcgBhAGMAdABpAG4AZwAuAC4ALgAiAAoAaQBmACAAKABUAGUAcwB0AC0AUABhAHQAaAAgACQAdABtAHAAKQAgAHsAIABSAGUAbQBvAHYAZQAtAEkAdABlAG0AIAAkAHQAbQBwACAALQBSAGUAYwB1AHIAcwBlACAALQBGAG8AcgBjAGUAIAB9AAoAQQBkAGQALQBUAHkAcABlACAALQBBAHMAcwBlAG0AYgBsAHkATgBhAG0AZQAgAFMAeQBzAHQAZQBtAC4ASQBPAC4AQwBvAG0AcAByAGUAcwBzAGkAbwBuAC4ARgBpAGwAZQBTAHkAcwB0AGUAbQAKAFsAUwB5AHMAdABlAG0ALgBJAE8ALgBDAG8AbQBwAHIAZQBzAHMAaQBvAG4ALgBaAGkAcABGAGkAbABlAF0AOgA6AEUAeAB0AHIAYQBjAHQAVABvAEQAaQByAGUAYwB0AG8AcgB5ACgAJAB6AGkAcAAsACAAJAB0AG0AcAApAAoAJABzAHUAYgAgACAAPQAgAEcAZQB0AC0AQwBoAGkAbABkAEkAdABlAG0AIAAkAHQAbQBwACAALQBEAGkAcgBlAGMAdABvAHIAeQAgAHwAIABTAGUAbABlAGMAdAAtAE8AYgBqAGUAYwB0ACAALQBGAGkAcgBzAHQAIAAxAAoAJABkAGUAcwB0ACAAPQAgAEoAbwBpAG4ALQBQAGEAdABoACAAJABiAGEAcwBlACAAJwBuAG8AZABlACcACgBpAGYAIAAoAFQAZQBzAHQALQBQAGEAdABoACAAJABkAGUAcwB0ACkAIAB7ACAAUgBlAG0AbwB2AGUALQBJAHQAZQBtACAAJABkAGUAcwB0ACAALQBSAGUAYwB1AHIAcwBlACAALQBGAG8AcgBjAGUAIAB9AAoATQBvAHYAZQAtAEkAdABlAG0AIAAkAHMAdQBiAC4ARgB1AGwAbABOAGEAbQBlACAAJABkAGUAcwB0AAoAUgBlAG0AbwB2AGUALQBJAHQAZQBtACAAJAB6AGkAcAAgAC0ARgBvAHIAYwBlACAALQBFAHIAcgBvAHIAQQBjAHQAaQBvAG4AIABTAGkAbABlAG4AdABsAHkAQwBvAG4AdABpAG4AdQBlAAoAUgBlAG0AbwB2AGUALQBJAHQAZQBtACAAJAB0AG0AcAAgAC0AUgBlAGMAdQByAHMAZQAgAC0ARgBvAHIAYwBlACAALQBFAHIAcgBvAHIAQQBjAHQAaQBvAG4AIABTAGkAbABlAG4AdABsAHkAQwBvAG4AdABpAG4AdQBlAAoAVwByAGkAdABlAC0ASABvAHMAdAAgACIAWwBPAEsAXQAgACAATgBvAGQAZQAuAGoAcwAgAHIAZQBhAGQAeQAgAGEAdAA6ACAAJABkAGUAcwB0ACIACgA=

powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand %B64%
if errorlevel 1 (
    echo.
    echo [ERROR] Failed to download Node.js.
    echo         - Check your internet connection and try again.
    echo         - Or manually download node-v22.16.0-win-x64.zip from nodejs.org
    echo           extract it and rename the inner folder to: node\
    pause
    exit /b 1
)

if not exist "%NODE_EXE%" (
    echo [ERROR] Download finished but node.exe not found. Zip may be corrupt.
    echo         Delete node_tmp\ then re-run.
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
echo [OK]  Node.js !NODE_VER! ready.

:check_openclaw
rem ============================================
rem STEP 2: Ensure OpenClaw is installed
rem ============================================
echo.
echo [2/4] Checking OpenClaw...

if exist "%OPENCLAW_ENTRY%" (
    echo [OK]  OpenClaw found.
    goto :setup_env
)

echo [INFO] OpenClaw not installed. Installing - one time only, ~30 MB...
echo.

if not exist "%NPM_CLI%" (
    echo [ERROR] npm not found: %NPM_CLI%
    echo         Node.js download may be incomplete.
    echo         Delete node\ and re-run start.bat.
    pause
    exit /b 1
)

if not exist "%PKG_DIR%" mkdir "%PKG_DIR%"

echo [INFO] Trying registry: https://registry.npmmirror.com
"%NODE_EXE%" "%NPM_CLI%" install -g openclaw --prefix "%PKG_DIR%" --registry https://registry.npmmirror.com
if not errorlevel 1 goto :verify_install

echo [WARN] China registry failed. Trying: https://registry.npmjs.org
"%NODE_EXE%" "%NPM_CLI%" install -g openclaw --prefix "%PKG_DIR%" --registry https://registry.npmjs.org
if not errorlevel 1 goto :verify_install

echo.
echo [ERROR] Failed to install OpenClaw from all registries.
echo         Check your internet connection and try again.
pause
exit /b 1

:verify_install
if not exist "%OPENCLAW_ENTRY%" (
    echo.
    echo [ERROR] npm install succeeded but entry file not found.
    echo         Expected: %OPENCLAW_ENTRY%
    echo.
    echo  Actual contents of %PKG_DIR%\node_modules\:
    dir "%PKG_DIR%\node_modules\" /b 2^>nul
    echo.
    echo  Please report at: https://github.com/SonicBotMan/openclaw-portable/issues
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

set "PATH=%NODE_DIR%;%PKG_DIR%\node_modules\.bin;%PATH%"
set "OPENCLAW_HOME=%SCRIPT_DIR%\data"

if not exist "%SCRIPT_DIR%\data"      mkdir "%SCRIPT_DIR%\data"
if not exist "%SCRIPT_DIR%\workspace" mkdir "%SCRIPT_DIR%\workspace"

rem Write minimal openclaw.json if not yet present
if not exist "%OPENCLAW_HOME%\openclaw.json" (
    echo [INFO] Writing default openclaw.json...
    (
        echo {"gateway":{"mode":"local"}}
    ) > "%OPENCLAW_HOME%\openclaw.json"
)

echo [OK]  Environment ready.

rem ============================================
rem STEP 4: Run OpenClaw Gateway (FOREGROUND)
rem  "gateway run"   = foreground, correct for portable use
rem  "gateway start" = system service manager, DO NOT USE
rem  Window stays open. Close with stop.bat.
rem ============================================
echo [4/4] Starting OpenClaw Gateway...
echo.
echo   URL  : http://localhost:%GATEWAY_PORT%
echo   Stop : run stop.bat  or  close this window
echo.
echo ==========================================
echo.

"%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run

echo.
if errorlevel 1 (
    echo [ERROR] Gateway exited with error. See output above.
    echo.
    echo  Quick fixes:
    echo    1. Port %GATEWAY_PORT% busy  ^>  netstat -aon ^| findstr :%GATEWAY_PORT%
    echo    2. Corrupted install    ^>  delete openclaw-pkg\ then re-run
) else (
    echo [INFO] Gateway stopped normally.
)
echo.
pause
