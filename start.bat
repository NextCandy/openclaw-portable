@echo off
chcp 936 >nul
setlocal enabledelayedexpansion
title OpenClaw Portable

echo.
echo ========================================
echo    OpenClaw Portable - Windows ?????
echo ========================================
echo.

rem ??? ?????????(U??)
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

echo [??] ????: %SCRIPT_DIR%
echo.

rem ============================================
rem ??? Node.js (??????)
rem ============================================
set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"

if not exist "%NODE_EXE%" (
    echo [??] ???? node\node.exe
    echo ??????????????????????node\ ???????????
    pause
    exit /b 1
)

"%NODE_EXE%" --version >nul 2>&1
if errorlevel 1 (
    echo [??] node.exe ??????????????????????
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('"%NODE_EXE%" --version') do set NODE_VER=%%v
echo [OK] Node.js %NODE_VER% ??

rem ============================================
rem ??? OpenClaw
rem ============================================
set "NPM_GLOBAL=%SCRIPT_DIR%\npm-global"
set "OPENCLAW_CMD="

if exist "%NPM_GLOBAL%\openclaw.cmd" (
    set "OPENCLAW_CMD=%NPM_GLOBAL%\openclaw.cmd"
) else if exist "%NPM_GLOBAL%\bin\openclaw.cmd" (
    set "OPENCLAW_CMD=%NPM_GLOBAL%\bin\openclaw.cmd"
)

if "%OPENCLAW_CMD%"=="" (
    echo [??] ???? openclaw ???
    echo ?????? npm-global\ ????????
    pause
    exit /b 1
)

echo [OK] OpenClaw ??
echo.

rem ============================================
rem ??????
rem ============================================
set "PATH=%SCRIPT_DIR%\node;%SCRIPT_DIR%\node\bin;%NPM_GLOBAL%;%NPM_GLOBAL%\bin;%PATH%"
set "OPENCLAW_WORKSPACE=%SCRIPT_DIR%\workspace"
set "OPENCLAW_CONFIG_DIR=%SCRIPT_DIR%\config"
set "NODE_PATH=%NPM_GLOBAL%\lib\node_modules"

if not exist "%SCRIPT_DIR%\workspace" mkdir "%SCRIPT_DIR%\workspace"
if not exist "%SCRIPT_DIR%\config" mkdir "%SCRIPT_DIR%\config"
if not exist "%SCRIPT_DIR%\data" mkdir "%SCRIPT_DIR%\data"

rem ============================================
rem ?????? OpenClaw
rem ============================================
echo [??] ???? OpenClaw Gateway...
echo.

call "%OPENCLAW_CMD%" gateway start
if errorlevel 1 (
    echo.
    echo [??] ?????!
    echo ??? 3000 ??????????????
    pause
    exit /b 1
)

echo.
echo ========================================
echo   OK ??????!
echo   ????: http://localhost:3000
echo ========================================
echo.
echo ???????? stop.bat ????
echo.
pause
