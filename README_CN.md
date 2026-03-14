# 🚀 OpenClaw 便携版

### 全球首创完全离线 AI 助手 - 无需网络，即插即用

**中文** | [English](README.md) | [日本語](README_JP.md)

---

## 🎯 解决的问题

**传统 AI 助手的痛点：**
- ❌ 安装耗时 10-30 分钟
- ❌ 必须稳定网络连接
- ❌ 国内需要翻墙或镜像
- ❌ 换电脑需要重新安装
- ❌ 数据分散在各个设备

**结果？** 浪费时间、网络限制、隐私担忧。

---

## 💡 我们的方案：OpenClaw 便携版

**全球首创：**
- ✅ **完全离线运行** - 解压即用，无需网络
- ✅ **60 秒极速安装** - 解压即用
- ✅ **U盘即插即用** - AI 随身，数据随身
- ✅ **零痕迹运行** - 完美适配公司/公共电脑
- ✅ **自动同步** - 数据跟随你，而不是机器

**一个 U盘。一次点击。零烦恼。**

---

## 🌟 核心价值

| 特性 | 传统安装 | 便携版 |
|------|---------|-------|
| **安装时间** | 10-30 分钟 | **60 秒** |
| **需要网络** | ✅ 必须 | ❌ **不需要** |
| **下载大小** | ~500MB | **0** |
| **换电脑** | ❌ 重装 | ✅ **即插即用** |
| **数据同步** | ❌ 手动 | ✅ **自动** |
| **隐私保护** | ❌ 有痕迹 | ✅ **零痕迹** |
| **国内体验** | 需要翻墙 | **完美** |

---

## 📊 对比：便携版 vs 传统安装

### 传统 OpenClaw 安装方式

**痛点：**
```bash
# 步骤 1：安装 Node.js（10-15 分钟）
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# 步骤 2：安装 OpenClaw（5-10 分钟）
npm install -g openclaw

# 步骤 3：配置（5-10 分钟）
openclaw config init
# 编辑配置文件...

# 步骤 4：换电脑重来一遍！
```

**问题：**
- ❌ 需要稳定网络（下载 500MB+）
- ❌ 国内需要翻墙或镜像
- ❌ 每台电脑都要重新安装
- ❌ 数据分散在各个设备
- ❌ 共享电脑留下痕迹
- ❌ 安装耗时 10-30 分钟

### OpenClaw 便携版

**解决方案：**
```bash
# 步骤 1：解压（1 分钟）
unzip OpenClaw-Portable-v4.1.0.zip

# 步骤 2：运行（30 秒）
./start.sh

# 完成！🎉
```

**优势：**
- ✅ 零下载（全部预装）
- ✅ 离线可用（99% 的时间）
- ✅ U盘随身带（AI 走哪跟哪）
- ✅ 数据自动同步
- ✅ 退出零痕迹
- ✅ 60 秒启动

### 详细对比

| 特性 | 传统安装 | 便携版 |
|------|---------|-------|
| **安装时间** | 10-30 分钟 | **60 秒** |
| **需要网络** | ✅ 是（下载 500MB+） | ❌ **不需要** |
| **需要翻墙（国内）** | ✅ 是 | ❌ **不需要** |
| **换电脑** | ❌ 每次重装 | ✅ **USB 即用** |
| **数据同步** | ❌ 手动 | ✅ **自动** |
| **隐私保护（共享电脑）** | ❌ 有痕迹 | ✅ **零痕迹** |
| **配置保存** | ❌ 每台机器单独配置 | ✅ **USB 随身带** |
| **Node.js 安装** | ✅ 需要 | ❌ **预装** |
| **OpenClaw 安装** | ✅ 需要 | ❌ **预装** |
| **离线使用** | ❌ 不能 | ✅ **99% 离线** |

**结论：** OpenClaw 便携版消除了传统安装的所有痛点，同时增加了便携性和隐私保护。

---

## 🎯 适用场景

### ✅ 完美适配

| 场景 | 为什么完美 |
|------|-----------|
| **公司电脑** | 零痕迹，数据在 U盘 |
| **网吧/公共电脑** | 即插即用，关闭即清 |
| **无网络环境** | 几乎完全离线（仅 Git 需网络） |
| **多设备切换** | 数据自动同步，无缝切换 |
| **国内网络** | 无需翻墙，无需镜像 |

### ⚠️ 注意事项

- **Git 安装** - 首次使用需要网络（系统通常已安装）
- **大小** - 679MB（完整运行环境）
- **更新** - 在有网络环境中运行 `npm install -g openclaw@latest`

---

## 🚀 快速开始

### Windows 用户

**1 分钟快速启动：**
```batch
# 1. 解压到 U盘（1 分钟）
解压 OpenClaw-Portable-v4.1.0.zip

# 2. 双击启动（首次 30 秒）
双击 start.bat

# 3. 访问
打开浏览器 → http://localhost:3000

# 4. 关闭
双击 stop.bat
```

**✅ 完成！数据在 U盘，本地零痕迹**

### Linux/macOS 用户

```bash
# 1. 解压
tar -xzf OpenClaw-Portable-v4.1.0.tar.gz

# 2. 启动
cd /media/$(whoami)/*/OpenClaw-Portable
./start.sh

# 3. 访问
打开浏览器 → http://localhost:3000

# 4. 关闭
./stop.sh
```

---

## 📦 包含内容

```
OpenClaw-Portable/
├── node/              ← Node.js 22.14.0 (192MB)
├── npm-global/        ← OpenClaw 2026.3.12 (487MB)
├── start.bat          ← Windows 智能启动
├── stop.bat           ← Windows 智能关闭
├── start.sh           ← Linux/macOS 智能启动
├── stop.sh            ← Linux/macOS 智能关闭
└── config/            ← 配置目录
```

**总大小：** 157MB（压缩包）→ 679MB（解压后）

---

## 📋 系统要求

| 平台 | 要求 |
|------|------|
| **Windows** | Windows 10 2004+ / Windows 11 |
| **Linux** | Ubuntu 20.04+ / Debian 11+ |
| **macOS** | macOS 10.15+ |
| **U盘** | 至少 1GB 可用空间 |

---

## ⚠️ 安全提示

**请勿分享以下文件：**
- `config/openclaw.json` - 包含 API keys
- `data/.last_usb` - 包含路径信息

**权限自动设置：**
- 配置文件：`600`（仅所有者可读写）
- 日志文件：`640`（所有者读写，组只读）

---

## 🔄 更新

```bash
# 在有网络环境中
cd OpenClaw-Portable

# 更新 OpenClaw
export PATH="$PWD/node/bin:$PWD/npm-global/bin:$PATH"
npm install -g openclaw@latest
```

---

## 📥 下载

- **GitHub Release**: https://github.com/SonicBotMan/openclaw-portable/releases
- **镜像下载（国内）**: https://npmmirror.com/mirrors/openclaw-portable/

---

## ❓ 常见问题

<details>
<summary><b>Q: 为什么这么大？</b></summary>

包含完整运行环境：
- Node.js 运行时（192MB）
- OpenClaw + 依赖（487MB）

这是完全离线的代价。
</details>

<details>
<summary><b>Q: 能在公司电脑用吗？</b></summary>

可以！所有数据在 U盘，关闭后本地零痕迹。
</details>

<details>
<summary><b>Q: 国内网络能用吗？</b></summary>

完美适配！无需翻墙，无需镜像，开箱即用。
</details>

<details>
<summary><b>Q: 如何更新？</b></summary>

在有网络环境中运行：
```bash
export PATH="$PWD/node/bin:$PWD/npm-global/bin:$PATH"
npm install -g openclaw@latest
```
</details>

---

## 🤝 贡献

欢迎贡献！查看 [CONtributing.md](CONTRIBUTING.md)

---

## 📄 许可证

MIT License - 查看 [LICENSE](LICENSE)

---

## 🌟 Star History

如果这个项目帮到你，请 ⭐️ star！

[![Star History Chart](https://api.star-history.com/svg?repos=SonicBotMan/openclaw-portable&type=Date)](https://star-history.com/#SonicBotMan/openclaw-portable&Date)

---

**版本：** 4.1.0 | **发布日期：** 2026-03-14 | **Node.js：** v22.14.0 | **OpenClaw：** 2026.3.12

---

<p align="center">
  <b>为全球 AI 社区用 ❤️ 打造</b>
</p>
