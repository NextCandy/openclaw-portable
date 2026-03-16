# 📥 下载完整离线包

由于 GitHub 的单文件大小限制（2GB），完整的离线包（1.2GB）无法直接上传到 Release。

 我们需要分两步下载。

---

## 🎯 下载方式

### 方式 1: 分别下载（推荐）

**1. 下载基础包（约 150MB）**
- 包含：Node.js + OpenClaw + llama.cpp
- 下载地址：见 GitHub Release

下方资源 `OpenClaw-Portable-v6.0.0-base.tar.gz`

**2. 下载模型文件（约 900MB）**
```bash
mkdir -p OpenClaw-Portable-v6.0.0-windows/llm/models
cd OpenClaw-Portable-v6.0.0-windows/llm/models
wget https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf
```

### 方式 2: 使用构建脚本

```bash
git clone https://github.com/SonicBotMan/openclaw-portable.git
cd openclaw-portable
./build-offline-package.sh
```

构建完成后，完整离线包位于：`dist/OpenClaw-Portable-v6.0.0-windows-offline.tar.gz`

---

## 💡 推荐方案

**首次使用：推荐方式 1（分别下载）**
- 基础包较小（150MB）
- 模型下载一次即可重复使用

**开发者：推荐方式 2（构建脚本）**
- 完全自动化
- 可自定义配置

---

## 📦 文件大小

| 组件 | 大小 | 说明 |
|------|------|------|
| 基础包 | ~150 MB | Node.js + OpenClaw + llama.cpp |
| 模型文件 | ~900 MB | Qwen2.5-1.5B-Instruct Q4_K_M |
| 完整包 | ~1.2 GB | 上述所有内容 |

---

**注意：** 由于 GitHub 限制，完整的离线包（1.2GB）超过 GitHub 的单文件上传限制（2GB）。如需完整包，请：
1. 使用基础包 + 单独下载模型
2. 或使用构建脚本自行构建
3. 或联系维护者获取云盘下载链接
