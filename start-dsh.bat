@echo off
setlocal EnableExtensions
chcp 65001 >nul
title DeepSeek Harness (dsh) 一键启动
cd /d "%~dp0"

set "PORT=3080"
if not "%~1"=="" set "PORT=%~1"
set "URL=http://127.0.0.1:%PORT%"

echo ============================================
echo   DeepSeek Harness (dsh) 一键启动脚本
echo ============================================
echo.

rem ---- 1. 检查 Node.js ----
where node >nul 2>nul
if errorlevel 1 (
    echo [错误] 未检测到 Node.js，请先安装: https://nodejs.org/
    pause
    exit /b 1
)

rem ---- 2. 已在运行？直接打开浏览器 ----
curl -s -o NUL --max-time 2 "%URL%" >nul 2>nul
if not errorlevel 1 (
    echo [提示] dsh 似乎已在运行，直接打开浏览器...
    start "" "%URL%"
    pause
    exit /b 0
)

rem ---- 3. 选择启动方式 ----
set "MODE=npx"
if exist "apps\cli\src\bin.ts" set "MODE=source"
if "%MODE%"=="source" (
    where pnpm >nul 2>nul
    if errorlevel 1 (
        echo [警告] 检测到源码目录但缺少 pnpm，改用 npx 安装版。
        set "MODE=npx"
    )
)

if "%MODE%"=="source" (
    echo [启动] 源码模式: pnpm dsh web --port %PORT%
    start "dsh web" cmd /k "pnpm dsh web --port %PORT%"
) else (
    echo [启动] 安装版: npx --yes @deepseek-ai/dsh web --port %PORT%
    start "dsh web" cmd /k "npx --yes @deepseek-ai/dsh web --port %PORT%"
)

rem ---- 4. 等待端口就绪（最长 90 秒）----
echo [等待] 正在等待 dsh 启动 (最长 90 秒)...
set /a tries=0
:waitloop
set /a tries+=1
if %tries% gtr 90 (
    echo [错误] 等待超时，请查看 "dsh web" 窗口的日志。
    pause
    exit /b 1
)
curl -s -o NUL --max-time 1 "%URL%" >nul 2>nul
if errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto waitloop
)

echo [完成] dsh 已启动: %URL%
start "" "%URL%"
echo 浏览器已自动打开。服务在 "dsh web" 窗口运行，按 Ctrl+C 停止。
pause
endlocal
