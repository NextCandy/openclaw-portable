#!/bin/bash
# OpenClaw Portable - WSL2 首次安装脚本
# 使用方法：在 WSL2 中运行 ./install.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== OpenClaw Portable 安装向导 ===${NC}"
echo ""

# 检查 WSL
if [ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    echo -e "${YELLOW}⚠️  警告: 未检测到 WSL2${NC}"
    echo "此脚本仅适用于 Windows + WSL2 环境"
    echo ""
    read -p "是否继续安装？(y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 更新系统
echo -e "${GREEN}[1/4] 更新系统包...${NC}"
sudo apt update

# 安装 Node.js
echo ""
echo -e "${GREEN}[2/4] 安装 Node.js 20.x...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js 已安装: $(node --version)"
fi

# 安装 Git
echo ""
echo -e "${GREEN}[3/4] 安装 Git...${NC}"
if ! command -v git &> /dev/null; then
    sudo apt-get install -y git
else
    echo "Git 已安装: $(git --version)"
fi

# 安装 OpenClaw
echo ""
echo -e "${GREEN}[4/4] 安装 OpenClaw...${NC}"
if ! command -v openclaw &> /dev/null; then
    sudo npm install -g openclaw@latest
else
    echo "OpenClaw 已安装: $(openclaw --version)"
fi

# 验证安装
echo ""
echo -e "${GREEN}=== 验证安装 ===${NC}"
echo ""
echo "Node.js:   $(node --version)"
echo "npm:       $(npm --version)"
echo "Git:       $(git --version)"
echo "OpenClaw:  $(openclaw --version)"

# 设置权限
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$SCRIPT_DIR/start.sh"
chmod +x "$SCRIPT_DIR/stop.sh"

echo ""
echo -e "${GREEN}✅ 安装完成！${NC}"
echo ""
echo "使用方法："
echo "  ./start.sh  - 启动 OpenClaw"
echo "  ./stop.sh   - 停止 OpenClaw"
