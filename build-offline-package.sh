#!/usr/bin/env bash
# OpenClaw Portable v6.0.0 - 离线包构建脚本
# 用途：下载 Node.js + OpenClaw + llama.cpp + Qwen2.5-1.5B，打包成完全离线的 Release 包

set -euo pipefail

# 配置
NODE_VERSION="22.16.0"
OPENCLAW_VERSION="latest"
LLAMA_CPP_VERSION="b4265"
MODEL_NAME="qwen2.5-1.5b-instruct-q4_k_m.gguf"
MODEL_URL="https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/$MODEL_NAME"
OUTDIR="dist/OpenClaw-Portable-v6.0.0-windows"
MIRROR_NODE="https://npmmirror.com/mirrors/node"
MIRROR_NPM="https://registry.npmmirror.com"

echo "=========================================="
echo "  OpenClaw Portable v6.0.0 - 离线包构建"
echo "  🚀 With Built-in Local Model Support"
echo "=========================================="
echo ""

# 清理旧构建
echo "[1/7] 清理旧构建..."
rm -rf dist
mkdir -p "${OUTDIR}"
echo "   ✓ 清理完成"

# 下载 Node.js
echo "[2/7] 下载 Node.js ${NODE_VERSION}..."
NODE_URL="${MIRROR_NODE}/v${NODE_VERSION}/node-v${NODE_VERSION}-win-x64.zip"
curl -fsSL "${NODE_URL}" -o /tmp/node-win.zip
unzip -q /tmp/node-win.zip -d /tmp/
mv "/tmp/node-v${NODE_VERSION}-win-x64" "${OUTDIR}/node"
rm /tmp/node-win.zip
echo "   ✓ Node.js 已下载"

# 安装 OpenClaw
echo "[3/7] 安装 OpenClaw..."
mkdir -p "${OUTDIR}/openclaw-pkg"
node "${OUTDIR}/node/node_modules/npm/bin/npm-cli.js" \
  install -g openclaw@${OPENCLAW_VERSION} \
  --prefix "${OUTDIR}/openclaw-pkg" \
  --registry "${MIRROR_NPM}"
echo "   ✓ OpenClaw 已安装"

# [NEW] 下载 llama.cpp 二进制
echo "[4/7] 下载 llama.cpp..."
LLM_BIN_DIR="${OUTDIR}/llm/bin"
mkdir -p "$LLM_BIN_DIR"

# 下载 llama-server (Windows)
LLAMA_SERVER_URL="https://github.com/ggml-org/llama.cpp/releases/download/${LLAMA_CPP_VERSION}/llama-${LLAMA_CPP_VERSION}-bin-win-avx2-x64.zip"
curl -fsSL "${LLAMA_SERVER_URL}" -o /tmp/llama-server.zip
unzip -q /tmp/llama-server.zip -d /tmp/llama-server-tmp
# 查找并移动 llama-server.exe
find /tmp/llama-server-tmp -name "llama-server.exe" -exec mv {} "$LLM_BIN_DIR/llama-server-win32-avx2.exe" \;
rm -rf /tmp/llama-server.zip /tmp/llama-server-tmp
echo "   ✓ llama.cpp (Windows AVX2) 已下载"

# [NEW] 下载内置模型
echo "[5/7] 下载内置模型 (Qwen2.5-1.5B, ~900MB)..."
LLM_MODEL_DIR="${OUTDIR}/llm/models"
mkdir -p "$LLM_MODEL_DIR"

MODEL_FILE="$LLM_MODEL_DIR/qwen2.5-1.5b-instruct-q4_k_m.gguf"

# 检查模型是否已存在（GitHub Actions 预下载）
if [ -f "llm/models/qwen2.5-1.5b-instruct-q4_k_m.gguf" ]; then
    echo "   ✓ 检测到预下载的模型，移动到目标位置..."
    mv llm/models/qwen2.5-1.5b-instruct-q4_k_m.gguf "$MODEL_FILE"
elif [ -f "$MODEL_FILE" ]; then
    echo "   ✓ 模型已存在，跳过下载"
else
    echo "   ⏳ 下载中，请耐心等待..."
    
    # 方式 1: 从 GitHub Release 下载（更快）
    if [ "$USE_GITHUB_MODEL" = "true" ] || [ "$1" = "--github" ]; then
        echo "   📦 从 GitHub Release 下载..."
        cd "$LLM_MODEL_DIR"
        curl -L --progress-bar -o part1.bin \
          "https://github.com/SonicBotMan/openclaw-portable/releases/download/v6.0.0/qwen-model-part1.bin"
        curl -L --progress-bar -o part2.bin \
          "https://github.com/SonicBotMan/openclaw-portable/releases/download/v6.0.0/qwen-model-part2.bin"
        curl -L --progress-bar -o part3.bin \
          "https://github.com/SonicBotMan/openclaw-portable/releases/download/v6.0.0/qwen-model-part3.bin"
        
        echo "   🔧 合并模型文件..."
        cat part1.bin part2.bin part3.bin > qwen2.5-1.5b-instruct-q4_k_m.gguf
        rm -f part*.bin
        cd - > /dev/null
    else
        # 方式 2: 从 HuggingFace 下载
        curl -L --progress-bar -o "$MODEL_FILE" "$MODEL_URL"
    fi
    
    echo "   ✓ Qwen2.5-1.5B-Instruct Q4_K_M 已下载"
fi

# 复制启动脚本和配置
echo "[6/7] 复制启动脚本和配置..."
cp start.bat stop.bat check.bat "${OUTDIR}/"
cp -r config "${OUTDIR}/"
mkdir -p "${OUTDIR}/data" "${OUTDIR}/workspace" "${OUTDIR}/temp"
mkdir -p "${OUTDIR}/llm"  # 确保 llm 目录存在
echo "   ✓ 脚本已复制"

# 打包 Release
echo "[7/7] 打包 Release..."
cd dist

# 使用 tar 打包（兼容所有平台）
PACKAGE_NAME="OpenClaw-Portable-v6.0.0-windows-offline.tar.gz"
echo "   ⏳ 打包中（可能需要几分钟）..."
tar -czf "$PACKAGE_NAME" OpenClaw-Portable-v6.0.0-windows/
SIZE=$(du -h "$PACKAGE_NAME" | cut -f1)

echo ""
echo "=========================================="
echo "  ✅ 构建完成！"
echo "=========================================="
echo "  文件: $PACKAGE_NAME"
echo "  大小: ${SIZE}"
echo "  位置: dist/"
echo ""
echo "  包含内容:"
echo "  - Node.js ${NODE_VERSION} (预置)"
echo "  - OpenClaw ${OPENCLAW_VERSION} (预置)"
echo "  - llama.cpp ${LLAMA_CPP_VERSION} (预置)"
echo "  - Qwen2.5-1.5B-Instruct Q4_K_M (~900MB, 预置)"
echo "  - 启动脚本 (start.bat, stop.bat, check.bat)"
echo "  - 配置文件 (config/)"
echo ""
echo "  ✅ 完全离线运行 - 无需任何网络连接"
echo "  ✅ 内置本地模型 - 零 API 成本"
echo "=========================================="
