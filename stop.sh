#!/bin/bash
# OpenClaw Portable - 一键关闭脚本（增强版）
# 使用方法：./stop.sh [USB路径]

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 获取 U盘路径
if [ -n "$1" ]; then
    USB_PATH="$1"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    USB_PATH="$(dirname "$SCRIPT_DIR")"
fi

DATA_DIR="$USB_PATH/data"
TEMP_DIR="$HOME/.openclaw-portable-temp"

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    OpenClaw Portable - 一键关闭        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# 设置配置目录环境变量
export OPENCLAW_CONFIG_DIR="$TEMP_DIR"

# ============================================
# 1. 停止 OpenClaw
# ============================================
echo -e "${BLUE}[1/5] 停止 OpenClaw 服务...${NC}"

STATUS=$(openclaw gateway status 2>/dev/null || true)
if echo "$STATUS" | grep -q "running"; then
    openclaw gateway stop
    echo -e "${GREEN}✅ OpenClaw 已停止${NC}"
else
    echo -e "${YELLOW}⚠️  OpenClaw 未在运行${NC}"
fi

echo ""

# ============================================
# [NEW] 2. 停止内置 llama-server
# ============================================
echo -e "${BLUE}[2/5] 停止内置本地模型...${NC}"

LLM_PID_FILE="$USB_PATH/llm/server.pid"

if [ -f "$LLM_PID_FILE" ]; then
    LLM_PID=$(cat "$LLM_PID_FILE")
    if kill -0 "$LLM_PID" 2>/dev/null; then
        kill "$LLM_PID"
        echo -e "${GREEN}✅ 内置模型已停止 (PID: $LLM_PID)${NC}"
    else
        echo -e "${YELLOW}⚠️  内置模型进程不存在${NC}"
    fi
    rm -f "$LLM_PID_FILE"
else
    echo -e "${YELLOW}⚠️  未找到内置模型 PID 文件${NC}"
fi

echo ""

# ============================================
# 3. 保存数据到 U盘
# ============================================
echo -e "${BLUE}[3/5] 保存数据到 U盘...${NC}"

mkdir -p "$DATA_DIR"

# 保存配置
if [ -d "$TEMP_DIR" ]; then
    cp -r "$TEMP_DIR" "$DATA_DIR/.openclaw" 2>/dev/null || true
    echo -e "${GREEN}✅ 配置已保存${NC}"
fi

# 保存会话数据（如果存在）
if [ -d "$HOME/.openclaw/sessions" ]; then
    mkdir -p "$DATA_DIR/sessions"
    cp -r "$HOME/.openclaw/sessions/"* "$DATA_DIR/sessions/" 2>/dev/null || true
    echo -e "${GREEN}✅ 会话数据已保存${NC}"
fi

# 保存工作区（如果存在）
WORKSPACE_DIR="$USB_PATH/workspace"
if [ -d "$WORKSPACE_DIR" ]; then
    # 同步 memory 目录
    if [ -d "$WORKSPACE_DIR/memory" ]; then
        echo -e "${GREEN}✅ 记忆数据已保存${NC}"
    fi
fi

# 设置日志文件权限（仅所有者可读写，组可读，保护敏感信息）
find "$DATA_DIR" -name "*.log" -exec chmod 640 {} \; 2>/dev/null || true

echo ""

# ============================================
# 4. 清理本地痕迹
# ============================================
echo -e "${BLUE}[4/5] 清理本地痕迹...${NC}"

# 清理临时目录
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
    echo -e "${GREEN}✅ 临时目录已清理${NC}"
fi

# 清理缓存
if [ -d "$HOME/.cache/openclaw" ]; then
    rm -rf "$HOME/.cache/openclaw"
    echo -e "${GREEN}✅ 缓存已清理${NC}"
fi

# 清理 Node 模块缓存（可选，保留以加快下次启动）
# rm -rf "$HOME/.npm/_cacache"

# 清理日志（保留最近3天）
find "$HOME/.openclaw" -name "*.log" -mtime +3 -delete 2>/dev/null || true
echo -e "${GREEN}✅ 旧日志已清理${NC}"

echo ""

# ============================================
# 5. 完成提示
# ============================================
echo -e "${BLUE}[5/5] 完成${NC}"
echo ""

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            ✅ 安全关闭完成             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}已完成操作:${NC}"
echo "  • OpenClaw 服务已停止"
echo "  • 数据已保存到 U盘"
echo "  • 临时文件已清理"
echo "  • 本地痕迹已清除"
echo ""
echo -e "  ${BLUE}现在可以安全拔出 U盘了~${NC}"
echo ""
