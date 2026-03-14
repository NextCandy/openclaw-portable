@echo off
chcp 65001 >nul
title OpenClaw Portable - 环境检测

echo.
echo ========================================
echo    OpenClaw Portable - 环境检测工具
echo ========================================
echo.

:: 检测 WSL
echo [检测] WSL2...
wsl --status >nul 2>&1
if errorlevel 1 (
    echo    ❌ WSL2 未安装
    echo    解决: wsl --install -d Ubuntu
) else (
    echo    ✅ WSL2 已安装
)

:: 检测 Node.js（在 WSL 中）
echo [检测] Node.js...
wsl -e node --version >nul 2>&1
if errorlevel 1 (
    echo    ⚠️  Node.js 未安装（首次启动时会自动安装）
) else (
    for /f %%i in ('wsl -e node --version') do echo    ✅ Node.js: %%i
)

:: 检测 OpenClaw（在 WSL 中）
echo [检测] OpenClaw...
wsl -e openclaw --version >nul 2>&1
if errorlevel 1 (
    echo    ⚠️  OpenClaw 未安装（首次启动时会自动安装）
) else (
    echo    ✅ OpenClaw 已安装
)

echo.
echo ========================================
echo   检测完成！
echo ========================================
echo.
echo 如果看到 ⚠️ 警告，不用担心~
echo 首次运行 start.bat 时会自动安装
echo.
pause
