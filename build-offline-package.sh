#!/usr/bin/env bash
# OpenClaw Portable v5.0.2 - 离线包构建脚本
# 用途：下载 Node.js + OpenClaw，打包成完全离线的 Release 包

set -euo pipefail

# 配置
NODE_VERSION="22.16.0"
OPENCLAW_VERSION="latest"
OUTDIR="dist/OpenClaw-Portable-v5.0.2-windows"
MIRROR_NODE="https://npmmirror.com/mirrors/node"
MIRROR_NPM="https://registry.npmmirror.com"

echo "=========================================="
echo "  OpenClaw Portable v5.0.2 - 离线包构建"
echo "=========================================="
echo ""

# 清理旧构建
echo "[1/5] 清理旧构建..."
rm -rf dist
mkdir -p "${OUTDIR}"

# 下载 Node.js
echo "[2/5] 下载 Node.js ${NODE_VERSION}..."
NODE_URL="${MIRROR_NODE}/v${NODE_VERSION}/node-v${NODE_VERSION}-win-x64.zip"
curl -fsSL "${NODE_URL}" -o /tmp/node-win.zip
unzip -q /tmp/node-win.zip -d /tmp/
mv "/tmp/node-v${NODE_VERSION}-win-x64" "${OUTDIR}/node"
rm /tmp/node-win.zip

echo "   ✓ Node.js 已下载"

# 安装 OpenClaw
echo "[3/5] 安装 OpenClaw..."
mkdir -p "${OUTDIR}/openclaw-pkg"
node "${OUTDIR}/node/node_modules/npm/bin/npm-cli.js" \
  install -g openclaw@${OPENCLAW_VERSION} \
  --prefix "${OUTDIR}/openclaw-pkg" \
  --registry "${MIRROR_NPM}"

echo "   ✓ OpenClaw 已安装"

# 复制脚本和配置
echo "[4/5] 复制启动脚本和配置..."
cp start.bat stop.bat check.bat "${OUTDIR}/"
cp -r config "${OUTDIR}/"
mkdir -p "${OUTDIR}/data" "${OUTDIR}/workspace" "${OUTDIR}/temp"

echo "   ✓ 脚本已复制"

# 打包
echo "[5/5] 打包 Release..."
cd dist
zip -r "OpenClaw-Portable-v5.0.2-windows-offline.zip" OpenClaw-Portable-v5.0.2-windows/
SIZE=$(du -h "OpenClaw-Portable-v5.0.2-windows-offline.zip" | cut -f1)

echo ""
echo "=========================================="
echo "  ✅ 构建完成！"
echo "=========================================="
echo "  文件: OpenClaw-Portable-v5.0.2-windows-offline.zip"
echo "  大小: ${SIZE}"
echo "  位置: dist/"
echo ""
echo "  包含内容:"
echo "  - Node.js ${NODE_VERSION} (预置)"
echo "  - OpenClaw ${OPENCLAW_VERSION} (预置)"
echo "  - 启动脚本 (start.bat, stop.bat, check.bat)"
echo "  - 配置文件 (config/)"
echo ""
echo "  ✅ 完全离线运行 - 无需任何网络连接"
echo "=========================================="
