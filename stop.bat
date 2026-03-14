@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable - Stop

echo.
echo ==========================================
echo   OpenClaw Portable - Shutdown
echo ==========================================
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "OPENCLAW_ENTRY=%SCRIPT_DIR%\openclaw-pkg\node_modules\openclaw\bin\openclaw"
set "OPENCLAW_HOME=%SCRIPT_DIR%\data"

rem ============================================
rem STEP 1: Stop Gateway
rem ============================================
echo [1/2] Stopping OpenClaw Gateway...

if exist "%NODE_EXE%" (
    if exist "%OPENCLAW_ENTRY%" (
        "%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway stop
        if errorlevel 1 (
            echo [WARN] gateway stop returned error, falling back to taskkill...
            goto :taskkill_fallback
        )
        echo [OK]  Gateway stopped.
        goto :cleanup
    )
)

:taskkill_fallback
echo [INFO] Using taskkill to stop node processes...
taskkill /F /IM node.exe /T >nul 2>&1
if errorlevel 1 (
    echo [INFO] No node.exe processes found (already stopped).
) else (
    echo [OK]  node.exe processes terminated.
)

:cleanup
rem ============================================
rem STEP 2: Clean temp files
rem ============================================
echo.
echo [2/2] Cleaning up temp files...

if exist "%SCRIPT_DIR%\node.zip"  del /f /q "%SCRIPT_DIR%\node.zip"  >nul 2>&1
if exist "%SCRIPT_DIR%\node_tmp" rmdir /s /q "%SCRIPT_DIR%\node_tmp" >nul 2>&1

echo [OK]  Done.
echo.
echo ==========================================
echo   Safe to remove USB drive.
echo ==========================================
echo.
pause
