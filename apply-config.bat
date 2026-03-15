@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title OpenClaw 配置合并工具
color 0A
echo.
echo  ========================================
echo    OpenClaw 配置合并工具
echo  ========================================
echo.

rem === 解析脚本目录 ===
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

rem === 设置 Node.js 路径 ===
set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "PATH=%SCRIPT_DIR%\node;%PATH%"

rem === 检查 Node.js ===
echo [检查] Node.js...

if exist "%NODE_EXE%" (
    for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
    echo [OK] Node.js !NODE_VER! (本地)
) else (
    where node >nul 2>&1
    if !errorlevel! 1 (
        echo.
        echo [错误] 未找到 Node.js
        echo.
        echo 解决方案：
        echo   1. 确保已解压完整的离线包（包含 node/ 目录）
        echo   2. 或先运行 start.bat 启动环境
        echo.
        pause
        exit /b 1
    )
    for /f "tokens=*" %%v in ('node --version 2^>^&1') do set NODE_VER=%%v
    echo [OK] Node.js !NODE_VER! (系统)
)

echo.

rem === 检查 models.json ===
echo [检查] models.json...

if not exist "%SCRIPT_DIR%\models.json" (
    echo.
    echo [错误] 未找到 models.json
    echo.
    echo 解决方案：
    echo   1. 双击 config.bat 打开配置面板
    echo   2. 填写模型信息并下载 models.json
    echo   3. 将 models.json 复制到此目录
    echo   4. 重新运行 apply-config.bat
    echo.
    pause
    exit /b 1
)

echo [OK] models.json 存在
echo.

rem === 运行合并脚本 ===
echo [执行] 配置合并...
echo.

node "%SCRIPT_DIR%\install-models.js"

if %errorlevel% 1 (
    echo.
    echo ========================================
    echo  [错误] 配置合并失败
    echo ========================================
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo  ✅ 配置合并完成！
echo ========================================
echo.
echo 下一步：
echo   1. 运行 restart.bat 重启 Gateway
echo   2. 或运行 start.bat 启动 Gateway
echo.
echo ========================================
echo  按任意键退出...
pause >nul
