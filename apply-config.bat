@echo off
chcp 65001 >nul
title OpenClaw 配置合并工具
color 0A
echo.
echo  ========================================
echo    OpenClaw 配置合并工具
echo  ========================================
echo.

:: 检查 Node.js
where node >nul 2>&1
if %errorlevel 1 (
    echo [错误] 未找到 Node.js，    echo 请先运行 start.bat 安装 Node.js
    pause
    exit /b 1
)

:: 运行合并脚本
node install-models.js

if %errorlevel 1 (
    echo.
    echo [错误] 配置合并失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo  按任意键退出...
pause >nul
