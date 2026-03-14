@echo off
setlocal enabledelayedexpansion
title OpenClaw Portable - 停止服务

echo.
echo ==========================================
echo   OpenClaw Portable - 停止服务
echo ==========================================
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "GATEWAY_PORT=18789"

rem ============================================
rem [1/3] 停止 Gateway 进程
rem ============================================
echo [1/3] 停止 Gateway 进程...

rem 方法1: 通过 API 优雅停止
curl -fsSL "http://localhost:%GATEWAY_PORT%/api/gateway/stop" 2>nul
if not errorlevel 1 (
    echo [OK]  Gateway 已通过 API 停止
    timeout /t 2 /nobreak >nul
)

rem 方法2: 强制终止监听端口的进程
for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":%GATEWAY_PORT%" ^| findstr "LISTENING"') do (
    echo [INFO] 终止进程 PID %%a
    taskkill /F /PID %%a >nul 2>&1
)

echo [OK]  进程已停止

rem ============================================
rem [2/3] 清理临时文件
rem ============================================
echo.
echo [2/3] 清理临时文件...

rem 清理 temp 目录
if exist "%SCRIPT_DIR%\temp" (
    rd /s /q "%SCRIPT_DIR%\temp" 2>nul
    mkdir "%SCRIPT_DIR%\temp"
    echo [OK]  temp\ 已清理
)

rem 清理 npm 缓存（可选）
if exist "%SCRIPT_DIR%\node\npm-cache" (
    rd /s /q "%SCRIPT_DIR%\node\npm-cache" 2>nul
    echo [OK]  npm-cache\ 已清理
)

rem 清理系统临时文件（仅清理 OpenClaw 相关）
for %%f in ("%TEMP%\openclaw-*" "%TEMP%\node-*") do (
    if exist "%%f" (
        del /f /q "%%f" 2>nul
    )
)
echo [OK]  系统临时文件已清理

rem ============================================
rem [3/3] 验证清理结果
rem ============================================
echo.
echo [3/3] 验证清理结果...

rem 检查端口是否已释放
netstat -aon 2>nul | findstr ":%GATEWAY_PORT%" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [OK]  端口 %GATEWAY_PORT% 已释放
) else (
    echo [WARN] 端口 %GATEWAY_PORT% 仍在使用
    echo        可能需要手动终止进程
)

echo.
echo ==========================================
echo   ✅ OpenClaw 已完全停止
echo ==========================================
echo.
echo   已清理：
echo   - Gateway 进程
echo   - temp\ 目录
echo   - npm 缓存
echo   - 系统临时文件
echo.
echo   数据保留：
echo   - data\ (配置和数据)
echo   - workspace\ (工作空间)
echo   - config\ (配置文件)
echo.
pause
