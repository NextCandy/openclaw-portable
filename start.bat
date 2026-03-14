@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable v5.0

echo.
echo ==========================================
echo   OpenClaw Portable v5.0 - Offline Edition
echo ==========================================
echo.

rem === 解析脚本目录 ===
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

rem === 路径配置 ===
set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "NPM_CLI=%SCRIPT_DIR%\node\node_modules\npm\bin\npm-cli.js"
set "OPENCLAW_ENTRY=%SCRIPT_DIR%\openclaw-pkg\node_modules\openclaw\bin\openclaw"
set "OPENCLAW_HOME=%SCRIPT_DIR%\data"
set "GATEWAY_PORT=18789"
set "PATH=%SCRIPT_DIR%\node;%SCRIPT_DIR%\openclaw-pkg\node_modules\.bin;%PATH%"

echo [INFO] Script dir : %SCRIPT_DIR%
echo [INFO] Node dir   : %SCRIPT_DIR%\node
echo [INFO] Data dir   : %OPENCLAW_HOME%
echo.

rem ============================================
rem [1/5] 检测 Node.js（离线包必须预置）
rem ============================================
echo [1/5] 检测 Node.js...

if not exist "%NODE_EXE%" (
    echo.
    echo [ERROR] node\node.exe 未找到！
    echo.
    echo 这是一个离线包，Node.js 应该已经预置在 node\ 目录中。
    echo.
    echo 请确认您下载的是完整离线包：
    echo   OpenClaw-Portable-v5.0.0-windows-offline.zip
    echo.
    echo 如果使用的是 Bootstrap 版本，请使用 start-online.bat
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
echo [OK]  Node.js !NODE_VER! 已就绪

rem ============================================
rem [2/5] 检测 OpenClaw（离线包必须预置）
rem ============================================
echo.
echo [2/5] 检测 OpenClaw...

if not exist "%OPENCLAW_ENTRY%" (
    echo.
    echo [ERROR] openclaw 未找到！
    echo.
    echo 这是一个离线包，OpenClaw 应该已经预置在 openclaw-pkg\ 目录中。
    echo.
    echo 请确认您下载的是完整离线包：
    echo   OpenClaw-Portable-v5.0.0-windows-offline.zip
    echo.
    pause
    exit /b 1
)

echo [OK]  OpenClaw 已就绪

rem ============================================
rem [3/5] 检测端口冲突
rem ============================================
echo.
echo [3/5] 检测端口冲突...

netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if not errorlevel 1 (
    echo [WARN] 端口 %GATEWAY_PORT% 已被占用
    echo [INFO] 尝试使用备用端口 18790...
    set "GATEWAY_PORT=18790"
    
    netstat -aon 2>nul | findstr ":18790" | findstr "LISTENING" >nul
    if not errorlevel 1 (
        echo [ERROR] 备用端口 18790 也被占用
        echo         请手动修改 start.bat 中的 GATEWAY_PORT
        pause
        exit /b 1
    )
)

echo [OK]  端口 %GATEWAY_PORT% 可用

rem ============================================
rem [4/5] 设置环境
rem ============================================
echo.
echo [4/5] 设置环境...

rem 创建必要目录
if not exist "%SCRIPT_DIR%\data" mkdir "%SCRIPT_DIR%\data"
if not exist "%SCRIPT_DIR%\workspace" mkdir "%SCRIPT_DIR%\workspace"
if not exist "%SCRIPT_DIR%\temp" mkdir "%SCRIPT_DIR%\temp"

rem 创建默认配置（如果不存在）
if not exist "%OPENCLAW_HOME%\openclaw.json" (
    echo [INFO] 创建默认配置...
    (
        echo {^
        echo   "gateway": {^
        echo     "mode": "local"^
        echo   }^
        echo }
    ) > "%OPENCLAW_HOME%\openclaw.json"
)

echo [OK]  环境已就绪

rem ============================================
rem [5/5] 启动 OpenClaw Gateway
rem ============================================
echo.
echo [5/5] 启动 OpenClaw Gateway...
echo.
echo   访问地址: http://localhost:%GATEWAY_PORT%
echo   停止服务: 运行 stop.bat 或关闭此窗口
echo.
echo ==========================================
echo.

"%NODE_EXE%" "%OPENCLAW_ENTRY%" gateway run

rem === 退出处理 ===
echo.
if errorlevel 1 (
    echo [ERROR] OpenClaw 退出异常
    echo.
    echo 常见原因：
    echo   1. 端口 %GATEWAY_PORT% 被占用
    echo   2. 配置文件损坏 - 删除 data\openclaw.json 重试
    echo   3. 杀毒软件拦截 - 添加白名单
    echo.
) else (
    echo [INFO] OpenClaw 已正常停止
)
echo.
pause
