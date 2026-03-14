#!/bin/bash
# OpenClaw Portable - 一键启动脚本（完全离线版）
# 使用方法：./start.sh [USB路径]

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

CONFIG_DIR="$USB_PATH/config"
WORKSPACE_DIR="$USB_PATH/workspace"
DATA_DIR="$USB_PATH/data"
TEMP_DIR="$HOME/.openclaw-portable-temp"
NODE_DIR="$USB_PATH/node"
NPM_GLOBAL="$USB_PATH/npm-global"

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    OpenClaw Portable - 一键启动        ║${NC}"
echo -e "${GREEN}║        （完全离线版）                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# ============================================
# 1. 设置环境（优先使用U盘中的版本）
# ============================================
echo -e "${BLUE}[1/4] 设置环境...${NC}"
echo ""

# 设置 Node.js
if [ -d "$NODE_DIR" ] && [ -x "$NODE_DIR/bin/node" ]; then
    export PATH="$NODE_DIR/bin:$PATH"
    NODE_VERSION=$("$NODE_DIR/bin/node" --version)
    echo -e "${GREEN}✅ Node.js: $NODE_VERSION (U盘)${NC}"
else
    echo -e "${RED}❌ Node.js 未找到！${NC}"
    echo "请确保 U盘中包含 node/ 目录"
    exit 1
fi

# 设置 OpenClaw
if [ -d "$NPM_GLOBAL" ] && [ -x "$NPM_GLOBAL/bin/openclaw" ]; then
    export PATH="$NPM_GLOBAL/bin:$PATH"
    OPENCLAW_VERSION=$(openclaw --version 2>/dev/null || echo "未知")
    echo -e "${GREEN}✅ OpenClaw: $OPENCLAW_VERSION (U盘)${NC}"
else
    echo -e "${RED}❌ OpenClaw 未找到！${NC}"
    echo "请确保 U盘中包含 npm-global/ 目录"
    exit 1
fi

# 检测 Git（这个还是需要系统安装）
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}⚠️  Git 未安装，正在安装...${NC}"
    sudo apt-get update
    sudo apt-get install -y git
    echo -e "${GREEN}✅ Git 安装完成${NC}"
else
    echo -e "${GREEN}✅ Git: $(git --version | cut -d' ' -f3)${NC}"
fi

echo ""

# ============================================
# 2. 创建目录结构
# ============================================
echo -e "${BLUE}[2/4] 初始化工作目录...${NC}"

mkdir -p "$CONFIG_DIR"
mkdir -p "$WORKSPACE_DIR"
mkdir -p "$DATA_DIR"
mkdir -p "$TEMP_DIR"

# 从 U盘加载配置到本地
if [ -d "$DATA_DIR/.openclaw" ]; then
    cp -r "$DATA_DIR/.openclaw/"* "$TEMP_DIR/" 2>/dev/null || true
    echo -e "${GREEN}✅ 配置已从 U盘加载${NC}"
else
    # 创建默认配置
    mkdir -p "$TEMP_DIR"
    cat > "$TEMP_DIR/openclaw.json" << 'EOF'
{
  "port": 3000,
  "models": {
    "default": "zai/glm-5"
  }
}
EOF
    echo -e "${GREEN}✅ 默认配置已创建${NC}"
fi

echo ""

# ============================================
# 3. 设置环境变量
# ============================================
echo -e "${BLUE}[3/4] 设置环境变量...${NC}"

export OPENCLAW_WORKSPACE="$WORKSPACE_DIR"
export OPENCLAW_CONFIG_DIR="$TEMP_DIR"
export HOME="$TEMP_DIR"

echo -e "${GREEN}✅ 环境变量设置完成${NC}"
echo ""

# ============================================
# 4. 启动 OpenClaw
# ============================================
echo -e "${BLUE}[4/4] 启动 OpenClaw Gateway...${NC}"
echo ""

# 检查是否已在运行
if openclaw gateway status &>/dev/null | grep -q "running"; then
    echo -e "${YELLOW}⚠️  OpenClaw 已在运行，跳过启动${NC}"
else
    openclaw gateway start
    sleep 2
fi

# 验证启动
if curl -s http://localhost:3000/health &>/dev/null; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          ✅ 启动成功！                 ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${BLUE}访问地址:${NC} http://localhost:3000"
    echo -e "  ${BLUE}U盘路径:${NC}   $USB_PATH"
    echo ""
    echo -e "  ${GREEN}完全离线，无需网络 📦${NC}"
    echo ""
    echo -e "  ${YELLOW}使用完毕后运行 stop.sh 一键关闭${NC}"
else
    echo -e "${RED}❌ 启动失败，请检查日志${NC}"
    exit 1
fi
