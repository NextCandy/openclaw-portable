@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title OpenClaw Portable - 环境检测

echo.
echo ========================================
echo    OpenClaw Portable - 环境检测工具
echo ========================================
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "NODE_EXE=%SCRIPT_DIR%\node\node.exe"
set "NPM_CLI=%SCRIPT_DIR%\node\node_modules\npm\bin\npm-cli.js"
set "OPENCLAW_ENTRY=%SCRIPT_DIR%\openclaw-pkg\node_modules\openclaw\bin\openclaw"
set "GATEWAY_PORT=18789"

set PASS=0
set FAIL=0

rem ----------------------------------------
rem [1] Node.js
rem ----------------------------------------
echo [检测 1/4] Node.js (node\node.exe)...
if exist "%NODE_EXE%" (
    for /f "tokens=*" %%v in ('"%NODE_EXE%" --version 2^>^&1') do set NODE_VER=%%v
    echo    OK  Node.js !NODE_VER! 已就绪
    set /a PASS+=1
) else (
    echo    --  node\node.exe 不存在（首次运行 start.bat 会自动下载）
    set /a FAIL+=1
)

rem ----------------------------------------
rem [2] OpenClaw
rem ----------------------------------------
echo [检测 2/4] OpenClaw (openclaw-pkg\...)...
if exist "%OPENCLAW_ENTRY%" (
    echo    OK  OpenClaw 已安装
    set /a PASS+=1
) else (
    echo    --  OpenClaw 未安装（首次运行 start.bat 会自动安装）
    set /a FAIL+=1
)

rem ----------------------------------------
rem [3] Port 18789
rem ----------------------------------------
echo [检测 3/4] 端口 %GATEWAY_PORT% 是否被占用...
netstat -ano | findstr ":%GATEWAY_PORT% " >nul 2>&1
if errorlevel 1 (
    echo    OK  端口 %GATEWAY_PORT% 空闲，可以使用
    set /a PASS+=1
) else (
    echo    !!  端口 %GATEWAY_PORT% 已被占用！
    echo        请运行: netstat -aon | findstr :%GATEWAY_PORT%
    echo        找到占用进程后用任务管理器结束，或修改 start.bat 中的 GATEWAY_PORT
    set /a FAIL+=1
)

rem ----------------------------------------
rem [4] Data directories
rem ----------------------------------------
echo [检测 4/4] 数据目录...
if exist "%SCRIPT_DIR%\data\" (
    echo    OK  data\ 目录存在
) else (
    echo    --  data\ 目录不存在（start.bat 运行时会自动创建）
)
if exist "%SCRIPT_DIR%\workspace\" (
    echo    OK  workspace\ 目录存在
) else (
    echo    --  workspace\ 目录不存在（start.bat 运行时会自动创建）
)
set /a PASS+=1

echo.
echo ========================================
echo   检测完成：%PASS% 项正常  %FAIL% 项需关注
echo ========================================
echo.
if %FAIL%==0 (
    echo   一切就绪！直接运行 start.bat 即可启动 OpenClaw。
) else (
    echo   有 -- 提示的项目不是错误，首次运行 start.bat 会自动处理。
    echo   有 !! 提示的项目需要手动处理后再启动。
)
echo.
echo   访问地址: http://localhost:%GATEWAY_PORT%
echo.
pause
