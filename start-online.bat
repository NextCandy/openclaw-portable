@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable v5.0 (Online)

echo.
echo ==========================================
echo   OpenClaw Portable v5.0 - Online Edition
echo   首次运行需联网下载依赖 (~60MB)
echo ==========================================
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "NPM_CLI=%SCRIPT_DIR%\node\node_modules\npm\bin\npm-cli.js"
set "OPENCLAW_ENTRY=%SCRIPT_DIR%\openclaw-pkg\node_modules\openclaw\bin\openclaw"
set "GATEWAY_PORT=18789"

rem ============================================
rem [1/4] 下载 Node.js（如需）
rem ============================================
echo [1/4] 检测 Node.js...

if exist "%NODE_EXE%" (
    for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do echo [OK]  Node.js %%v 已存在
    goto :check_openclaw
)

echo [INFO] Node.js 未找到，开始下载 (~30MB)...
echo [INFO] 使用国内镜像源...

set "NODE_URL=https://npmmirror.com/mirrors/node/v22.16.0/node-v22.16.0-win-x64.zip"

rem 使用 Windows 10+ 内置的 curl.exe
curl -fsSL "%NODE_URL%" -o "%SCRIPT_DIR%\node.zip"

if errorlevel 1 (
    echo [ERROR] 下载失败
    echo         请检查网络连接
    pause
    exit /b 1
)

echo [INFO] 解压中...
powershell -NoProfile -Command "Expand-Archive -Path '%SCRIPT_DIR%\node.zip' -DestinationPath '%SCRIPT_DIR%\node_tmp' -Force"
move "%SCRIPT_DIR%\node_tmp\node-v22.16.0-win-x64" "%SCRIPT_DIR%\node"
del /f /q "%SCRIPT_DIR%\node.zip"
rd /s /q "%SCRIPT_DIR%\node_tmp"

for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do echo [OK]  Node.js %%v 下载完成

:check_openclaw
rem ============================================
rem [2/4] 安装 OpenClaw（如需）
rem ============================================
echo.
echo [2/4] 检测 OpenClaw...

if exist "%OPENCLAW_ENTRY%" (
    echo [OK]  OpenClaw 已存在
    goto :check_port
)

echo [INFO] OpenClaw 未找到，开始安装 (~30MB)...
echo [INFO] 使用国内镜像源...

mkdir "%SCRIPT_DIR%\openclaw-pkg"

"%NODE_EXE%" "%NPM_CLI%" install -g openclaw --prefix "%SCRIPT_DIR%\openclaw-pkg" --registry https://registry.npmmirror.com

if errorlevel 1 (
    echo [ERROR] 安装失败
    echo         请检查网络连接
    pause
    exit /b 1
)

echo [OK]  OpenClaw 安装完成

:check_port
rem ============================================
rem [3/4] 检测端口
rem ============================================
echo.
echo [3/4] 检测端口...

netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [WARN] 端口 %GATEWAY_PORT% 被占用，尝试备用端口...
    set "GATEWAY_PORT=18790"
)

echo [OK]  使用端口 %GATEWAY_PORT%

rem ============================================
rem [4/4] 启动
rem ============================================
echo.
echo [4/4] 启动 OpenClaw Gateway...
echo.
echo   访问: http://localhost:%GATEWAY_PORT%
echo   停止: 运行 stop.bat
echo.
echo ==========================================
echo.

if not exist "%SCRIPT_DIR%\data" mkdir "%SCRIPT_DIR%\data"

"%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run

echo.
if errorlevel 1 (
    echo [ERROR] 启动失败
) else (
    echo [INFO] 已停止
)
pause
