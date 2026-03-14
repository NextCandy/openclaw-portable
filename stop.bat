@echo off
chcp 65001 >nul
title OpenClaw Portable - 一键关闭

echo.
echo ========================================
echo    OpenClaw Portable - 一键关闭
echo ========================================
echo.

:: 获取当前目录（U盘路径）
set "USB_ROOT=%~dp0"
set "USB_ROOT=%USB_ROOT:~0,-1%"
set "DRIVE_LETTER=%USB_ROOT:~0,1%"
set "WSL_USB=/mnt/%DRIVE_LETTER%/openclaw-portable"

echo [信息] 正在保存数据并清理...
echo.

:: 执行 WSL 停止脚本
wsl -e bash -c "cd '%WSL_USB%' && ./stop.sh '%WSL_USB%'"

echo.
echo ========================================
echo   ✅ 已完成：
echo   - 数据已保存到 U盘
echo   - 临时文件已清理
echo   - OpenClaw 已停止
echo ========================================
echo.
echo 现在可以安全拔出 U盘了~
echo.
pause
