#!/bin/bash
# OpenClaw Portable - 创建离线安装包
# 使用方法：在能翻墙的机器上运行 ./create-offline.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    OpenClaw Portable - 离线包生成器    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OFFLINE_DIR="$SCRIPT_DIR/offline-cache"

echo -e "${BLUE}[1/4] 创建离线缓存目录...${NC}"
mkdir -p "$OFFLINE_DIR"

# 下载 Node.js 二进制（Linux x64）
echo ""
echo -e "${BLUE}[2/4] 下载 Node.js 20.x LTS...${NC}"
NODE_VERSION="20.11.0"
NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"
CHINA_NODE_URL="https://npmmirror.com/mirrors/node/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"

if [ ! -f "$OFFLINE_DIR/node.tar.xz" ]; then
    echo "尝试国内镜像..."
    if curl -L --progress-bar -o "$OFFLINE_DIR/node.tar.xz" "$CHINA_NODE_URL" 2>/dev/null; then
        echo -e "${GREEN}✅ Node.js 下载完成（国内镜像）${NC}"
    elif curl -L --progress-bar -o "$OFFLINE_DIR/node.tar.xz" "$NODE_URL" 2>/dev/null; then
        echo -e "${GREEN}✅ Node.js 下载完成（官方源）${NC}"
    else
        echo -e "${YELLOW}⚠️  Node.js 下载失败，请手动下载${NC}"
    fi
else
    echo -e "${GREEN}✅ Node.js 已缓存${NC}"
fi

# 缓存 OpenClaw
echo ""
echo -e "${BLUE}[3/4] 缓存 OpenClaw...${NC}"
if command -v openclaw &> /dev/null; then
    OPENCLAW_BIN=$(which openclaw)
    cp "$OPENCLAW_BIN" "$OFFLINE_DIR/openclaw" 2>/dev/null || true
    echo -e "${GREEN}✅ OpenClaw 已缓存${NC}"
else
    echo -e "${YELLOW}⚠️  OpenClaw 未安装，跳过缓存${NC}"
fi

# 缓存 npm 包（可选）
echo ""
echo -e "${BLUE}[4/4] 创建 npm 缓存配置...${NC}"
cat > "$OFFLINE_DIR/.npmrc" << 'EOF'
# 国内镜像配置
registry=https://registry.npmmirror.com
# 其他镜像
disturl=https://npmmirror.com/mirrors/node
sass_binary_site=https://npmmirror.com/mirrors/node-sass/
electron_mirror=https://npmmirror.com/mirrors/electron/
sqlite3_binary_site=https://npmmirror.com/mirrors/sqlite3/
EOF
echo -e "${GREEN}✅ npm 配置已创建${NC}"

# 计算总大小
TOTAL_SIZE=$(du -sh "$OFFLINE_DIR" | cut -f1)

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          ✅ 离线包创建完成             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "离线缓存目录: $OFFLINE_DIR"
echo "总大小: $TOTAL_SIZE"
echo ""
echo "包含文件:"
ls -lh "$OFFLINE_DIR/"
echo ""
echo -e "${YELLOW}提示: 将 offline-cache 目录一起复制到 U盘${NC}"
