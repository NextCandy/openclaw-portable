@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title OpenClaw Portable - 智能启动

echo.
echo ========================================
echo    OpenClaw Portable - 智能启动
echo ========================================
echo.

:: 获取当前脚本所在目录（U盘路径）
set "CURRENT_DIR=%~dp0"
set "CURRENT_DIR=%CURRENT_DIR:~0,-1%"

echo [信息] 当前目录: %CURRENT_DIR%
echo.

:: 检查 WSL
wsl --status >nul 2>&1
if errorlevel 1 (
    echo [错误] WSL2 未安装！
    echo.
    echo 正在为您安装 WSL2...
    wsl --install -d Ubuntu
    if errorlevel 1 (
        echo [提示] 请手动运行以下命令（以管理员身份）：
        echo wsl --install -d Ubuntu
        echo 然后重启电脑，再运行此脚本。
    )
    pause
    exit /b 1
)

:: ============================================
:: 智能检测 U盘路径（支持多 U盘）
:: ============================================
echo [检测] 正在搜索 U盘...

set "USB_FOUND=0"
set "USB_COUNT=0"
set "USB_LIST="

:: 检测所有盘符
for %%i in (c d e f g h i j k l m n o p q r s t u v w x y z) do (
    if exist "%%i:\openclaw-portable\start.bat" (
        set /a USB_COUNT+=1
        set "USB_!USB_COUNT!=%%i:"
        set "USB_LIST=!USB_LIST! %%i:"
        echo   [!USB_COUNT!] %%i: (检测到 OpenClaw Portable)
    )
)

:: 如果找到多个 U盘，让用户选择
if %USB_COUNT% gtr 1 (
    echo.
    echo [提示] 检测到多个 U盘，请选择：
    echo.
    set /p CHOICE="请输入序号 (1-%USB_COUNT%): "
    
    :: 验证输入
    if !CHOICE! lss 1 (
        echo [错误] 无效选择
        pause
        exit /b 1
    )
    if !CHOICE! gtr %USB_COUNT% (
        echo [错误] 无效选择
        pause
        exit /b 1
    )
    
    :: 设置选中的 U盘
    set "USB_ROOT=!USB_%CHOICE%!"
) else if %USB_COUNT% equ 1 (
    set "USB_ROOT=!USB_1!"
) else (
    :: 没找到，使用当前目录
    echo [警告] 未检测到 U盘，使用当前目录
    set "USB_ROOT=%CURRENT_DIR%"
)

:: 转换为 WSL 路径（动态计算，支持任意目录名）
set "SCRIPT_FULL=%~dp0"
set "SCRIPT_FULL=%SCRIPT_FULL:~0,-1%"
set "DRIVE_LETTER=%SCRIPT_FULL:~0,1%"
set "SCRIPT_PATH=%SCRIPT_FULL:~2%"
set "SCRIPT_PATH=%SCRIPT_PATH:\=/%"
set "WSL_USB=/mnt/%DRIVE_LETTER%%SCRIPT_PATH%"

echo.
echo [信息] 使用 U盘: %USB_ROOT%
echo [信息] WSL路径: %WSL_USB%
echo.

:: ============================================
:: 保存上次使用的路径（可选）
:: ============================================
if not exist "%USB_ROOT%\openclaw-portable\data" mkdir "%USB_ROOT%\openclaw-portable\data"
echo "%USB_ROOT%" > "%USB_ROOT%\openclaw-portable\data\.last_usb"

:: ============================================
:: 执行启动
:: ============================================
echo [启动] 正在启动 OpenClaw...
echo.
wsl -e bash -c "cd '%WSL_USB%' && chmod +x *.sh && ./start.sh '%WSL_USB%'"

echo.
echo ========================================
echo   ✅ OpenClaw 已启动！
echo   访问地址: http://localhost:3000
echo ========================================
echo.
echo 💡 记住 U盘路径: %USB_ROOT%
echo 💡 使用完毕后运行 stop.bat 一键关闭
echo.
pause
