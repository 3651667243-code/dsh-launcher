#!/usr/bin/env sh
# DeepSeek Harness (dsh) 一键启动脚本 (Linux / macOS)
# 用法: ./start-dsh.sh [port]   默认端口 3080
set -e
cd "$(dirname "$0")"

PORT="${1:-3080}"
URL="http://127.0.0.1:${PORT}"

echo "============================================"
echo "  DeepSeek Harness (dsh) 一键启动脚本"
echo "============================================"
echo

# 1. 检查 node
if ! command -v node >/dev/null 2>&1; then
    echo "[错误] 未检测到 Node.js，请先安装: https://nodejs.org/"
    exit 1
fi

open_url() {
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$1" >/dev/null 2>&1 &
    elif command -v open >/dev/null 2>&1; then
        open "$1"
    else
        echo "请手动打开: $1"
    fi
}

# 2. 已在运行？直接打开浏览器
if curl -s -o /dev/null --max-time 2 "$URL" >/dev/null 2>&1; then
    echo "[提示] dsh 似乎已在运行，直接打开浏览器..."
    open_url "$URL"
    exit 0
fi

# 3. 选择启动方式
MODE=npx
if [ -f "apps/cli/src/bin.ts" ]; then MODE=source; fi
if [ "$MODE" = "source" ] && ! command -v pnpm >/dev/null 2>&1; then
    echo "[警告] 检测到源码目录但缺少 pnpm，改用 npx 安装版。"
    MODE=npx
fi

LOG="dsh-launcher.log"

# 4. 后台启动
if [ "$MODE" = "source" ]; then
    echo "[启动] 源码模式: pnpm dsh web --port $PORT"
    pnpm dsh web --port "$PORT" > "$LOG" 2>&1 &
else
    echo "[启动] 安装版: npx --yes @deepseek-ai/dsh web --port $PORT"
    npx --yes @deepseek-ai/dsh web --port "$PORT" > "$LOG" 2>&1 &
fi
SERVER_PID=$!

# 5. 等待端口就绪（最长 90 秒）
echo "[等待] 正在等待 dsh 启动 (最长 90 秒)..."
i=0
while [ "$i" -lt 90 ]; do
    if curl -s -o /dev/null --max-time 1 "$URL" >/dev/null 2>&1; then
        echo "[完成] dsh 已启动: $URL"
        open_url "$URL"
        echo "日志: $LOG | 按 Ctrl+C 停止服务"
        wait "$SERVER_PID"
        exit 0
    fi
    i=$((i + 1))
    sleep 1
done

echo "[错误] 等待超时，请查看 $LOG"
exit 1
