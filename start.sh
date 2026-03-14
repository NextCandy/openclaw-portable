#!/bin/bash
# OpenClaw Portable - 智能启动脚本（自动检测 U盘）
# 使用方法：./start-smart.sh

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    OpenClaw Portable - 智能启动        ║${NC}"
echo -e "${GREEN}║        （自动检测 U盘）                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# ============================================
# 1. 检测所有 U盘
# ============================================
echo -e "${BLUE}[1/5] 检测 U盘...${NC}"
echo ""

USB_LIST=()
USB_COUNT=0

# 检测 Linux 挂载点
if [ -d "/media" ]; then
    for user_dir in /media/*; do
        if [ -d "$user_dir" ]; then
            for usb in "$user_dir"/*; do
                if [ -d "$usb/openclaw-portable" ]; then
                    USB_COUNT=$((USB_COUNT + 1))
                    USB_LIST+=("$usb/openclaw-portable")
                    echo -e "  ${GREEN}[$USB_COUNT]${NC} $usb (检测到 OpenClaw Portable)"
                fi
            done
        fi
    done
fi

# 检测 macOS 挂载点
if [ -d "/Volumes" ]; then
    for usb in /Volumes/*; do
        if [ -d "$usb/openclaw-portable" ]; then
            USB_COUNT=$((USB_COUNT + 1))
            USB_LIST+=("$usb/openclaw-portable")
            echo -e "  ${GREEN}[$USB_COUNT]${NC} $usb (检测到 OpenClaw Portable)"
        fi
    done
fi

# 检测当前目录（基于内容指纹，不依赖特定目录名）
if [ -f "$SCRIPT_DIR/start.sh" ] && [ -d "$SCRIPT_DIR/node" ] && [ -d "$SCRIPT_DIR/npm-global" ]; then
    CURRENT_USB=$(dirname "$SCRIPT_DIR")
    
    # 检查是否已经在列表中
    FOUND=0
    for usb in "${USB_LIST[@]}"; do
        if [ "$usb" == "$SCRIPT_DIR" ]; then
            FOUND=1
            break
        fi
    done
    
    if [ $FOUND -eq 0 ]; then
        USB_COUNT=$((USB_COUNT + 1))
        USB_LIST+=("$SCRIPT_DIR")
        echo -e "  ${GREEN}[$USB_COUNT]${NC} $CURRENT_USB (当前目录)"
    fi
fi

# ============================================
# 2. 选择 U盘（如果找到多个）
# ============================================
if [ "$USB_COUNT" -eq 0 ]; then
    echo -e "${RED}❌ 未检测到 U盘！${NC}"
    echo ""
    echo "请确保："
    echo "1. U盘已插入电脑"
    echo "2. U盘包含 openclaw-portable 目录"
    echo "3. 有读取权限"
    exit 1
elif [ "$USB_COUNT" -eq 1 ]; then
    USB_PATH="${USB_LIST[0]}"
    echo ""
    echo -e "${GREEN}✅ 自动选择: $(dirname "$USB_PATH")${NC}"
else
    echo ""
    echo -e "${YELLOW}[提示] 检测到多个 U盘，请选择：${NC}"
    echo ""
    read -p "请输入序号 (1-$USB_COUNT): " CHOICE
    
    # 验证输入
    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "$USB_COUNT" ]; then
        echo -e "${RED}❌ 无效选择${NC}"
        exit 1
    fi
    
    USB_PATH="${USB_LIST[$((CHOICE - 1))]}"
fi

# ============================================
# 3. 设置环境变量
# ============================================
echo ""
echo -e "${BLUE}[2/5] 设置环境...${NC}"
echo ""

CONFIG_DIR="$USB_PATH/config"
WORKSPACE_DIR="$USB_PATH/workspace"
DATA_DIR="$USB_PATH/data"
TEMP_DIR="$HOME/.openclaw-portable-temp"
NODE_DIR="$USB_PATH/node"
NPM_GLOBAL="$USB_PATH/npm-global"

# 设置 Node.js
if [ -d "$NODE_DIR" ] && [ -x "$NODE_DIR/bin/node" ]; then
    export PATH="$NODE_DIR/bin:$PATH"
    NODE_VERSION=$("$NODE_DIR/bin/node" --version)
    echo -e "${GREEN}✅ Node.js: $NODE_VERSION${NC}"
else
    echo -e "${RED}❌ Node.js 未找到！${NC}"
    exit 1
fi

# 设置 OpenClaw
if [ -d "$NPM_GLOBAL" ] && [ -x "$NPM_GLOBAL/bin/openclaw" ]; then
    export PATH="$NPM_GLOBAL/bin:$PATH"
    OPENCLAW_VERSION=$(openclaw --version 2>/dev/null || echo "未知")
    echo -e "${GREEN}✅ OpenClaw: $OPENCLAW_VERSION${NC}"
else
    echo -e "${RED}❌ OpenClaw 未找到！${NC}"
    exit 1
fi

# 检测 Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}⚠️  Git 未安装，正在安装...${NC}"
    sudo apt-get update && sudo apt-get install -y git
fi
echo -e "${GREEN}✅ Git: $(git --version | cut -d' ' -f3)${NC}"

# ============================================
# 4. 保存上次使用的路径
# ============================================
echo ""
echo -e "${BLUE}[3/5] 保存路径记录...${NC}"

mkdir -p "$DATA_DIR"
echo "$USB_PATH" > "$DATA_DIR/.last_usb"
echo -e "${GREEN}✅ 路径已保存到: $DATA_DIR/.last_usb${NC}"

# ============================================
# 5. 初始化工作目录
# ============================================
echo ""
echo -e "${BLUE}[4/5] 初始化工作目录...${NC}"

mkdir -p "$CONFIG_DIR"
mkdir -p "$WORKSPACE_DIR"
mkdir -p "$DATA_DIR"
mkdir -p "$TEMP_DIR"

# 从 U盘加载配置到本地
if [ -d "$DATA_DIR/.openclaw" ]; then
    cp -r "$DATA_DIR/.openclaw/"* "$TEMP_DIR/" 2>/dev/null || true
    echo -e "${GREEN}✅ 配置已从 U盘加载${NC}"
else
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

# ============================================
# 6. 启动 OpenClaw
# ============================================
echo ""
echo -e "${BLUE}[5/5] 启动 OpenClaw Gateway...${NC}"

export OPENCLAW_WORKSPACE="$WORKSPACE_DIR"
export OPENCLAW_CONFIG_DIR="$TEMP_DIR"
export HOME="$TEMP_DIR"

# 检查是否已在运行
STATUS=$(openclaw gateway status 2>/dev/null || true)
if echo "$STATUS" | grep -q "running"; then
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
    echo -e "  ${BLUE}U盘路径:${NC}   $(dirname $USB_PATH)"
    echo ""
    echo -e "  ${GREEN}完全离线，无需网络 📦${NC}"
    echo ""
    echo -e "  ${YELLOW}使用完毕后运行 stop.sh 一键关闭${NC}"
else
    echo -e "${RED}❌ 启动失败，请检查日志${NC}"
    exit 1
fi
