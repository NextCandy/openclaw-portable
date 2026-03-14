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
set "PKG_DIR=%SCRIPT_DIR%\openclaw-pkg"
set "OPENCLAW_ENTRY=%PKG_DIR%\lib\node_modules\openclaw\bin\openclaw"

rem ============================================
rem STEP 1: Stop OpenClaw Gateway
rem ============================================
echo [1/2] Stopping OpenClaw Gateway...

if not exist "%NODE_EXE%" (
    echo [WARN] node.exe not found, trying taskkill fallback...
    taskkill /F /IM node.exe /T >nul 2>&1
    goto :cleanup
)

if not exist "%OPENCLAW_ENTRY%" (
    echo [WARN] OpenClaw not found, trying taskkill fallback...
    taskkill /F /IM node.exe /T >nul 2>&1
    goto :cleanup
)

"%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway stop
if errorlevel 1 (
    echo [WARN] gateway stop command failed, using taskkill...
    taskkill /F /IM node.exe /T >nul 2>&1
)

echo [OK]  OpenClaw stopped.

:cleanup
rem ============================================
rem STEP 2: Clean up temp files
rem ============================================
echo.
echo [2/2] Cleaning up...

set "TEMP_DIR=%USERPROFILE%\.openclaw-portable-temp"
if exist "%TEMP_DIR%" (
    rmdir /s /q "%TEMP_DIR%" >nul 2>&1
    echo [OK]  Temp files cleaned.
) else (
    echo [OK]  No temp files to clean.
)

echo.
echo ==========================================
echo   Done. Safe to remove USB drive.
echo ==========================================
echo.
pause
