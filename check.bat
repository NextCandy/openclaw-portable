@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title OpenClaw Portable - Environment Check

echo.
echo ========================================
echo    OpenClaw Portable - Environment Check
echo ========================================
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "NPM_CLI=%SCRIPT_DIR%\node\node_modules\npm\bin\npm-cli.js"
set "OPENCLAW_ENTRY=%SCRIPT_DIR%\openclaw-pkg\node_modules\openclaw\bin\openclaw"
set "GATEWAY_PORT=18789"

set PASS=0
set FAIL=0

rem ----------------------------------------
rem [1] Node.js
rem ----------------------------------------
echo [Check 1/4] Node.js (node\node.exe)...
if exist "%NODE_EXE%" (
    for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
    echo    OK  Node.js !NODE_VER! is ready
    set /a PASS+=1
) else (
    echo    FAIL node\node.exe not found
    set /a FAIL+=1
)

rem ----------------------------------------
rem [2] OpenClaw
rem ----------------------------------------
echo.
echo [Check 2/4] OpenClaw (openclaw-pkg)...
if exist "%OPENCLAW_ENTRY%" (
    echo    OK  OpenClaw is installed
    set /a PASS+=1
) else (
    echo    FAIL OpenClaw not found in openclaw-pkg\
    set /a FAIL+=1
)

rem ----------------------------------------
rem [3] Port availability
rem ----------------------------------------
echo.
echo [Check 3/4] Port %GATEWAY_PORT%...
netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo    OK  Port %GATEWAY_PORT% is available
    set /a PASS+=1
) else (
    echo    WARN Port %GATEWAY_PORT% is in use
    set /a FAIL+=1
)

rem ----------------------------------------
rem [4] Directories
rem ----------------------------------------
echo.
echo [Check 4/4] Directories...
set DIR_OK=1
if not exist "%SCRIPT_DIR%\data" (
    echo    WARN data\ not found
    set DIR_OK=0
)
if not exist "%SCRIPT_DIR%\workspace" (
    echo    WARN workspace\ not found
    set DIR_OK=0
)
if "%DIR_OK%"=="1" (
    echo    OK  All directories present
    set /a PASS+=1
) else (
    set /a FAIL+=1
)

rem ----------------------------------------
rem Summary
rem ----------------------------------------
echo.
echo ========================================
echo   Check Complete: %PASS% passed, %FAIL% failed
echo ========================================
echo.

if "%FAIL%"=="0" (
    echo [OK] Environment is ready
    echo      You can now run start.bat
) else (
    echo [WARN] Some checks failed
    echo        Please fix the issues above
)
echo.
pause
