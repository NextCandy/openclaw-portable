# OpenClaw Portable - 完全离线版

**🚀 真正的一键便携式 OpenClaw（完全离线）**

---

## ✨ 特性

- ✅ **预置 Node.js 22.14.0** - 无需下载
- ✅ **预置 OpenClaw 2026.3.12** - 无需下载
- ✅ **完全离线** - 无需网络即可使用
- ✅ **一键启动** - 双击 `start.bat`，自动配置环境
- ✅ **一键关闭** - 双击 `stop.bat`，自动保存数据、清理痕迹
- ✅ **数据持久化** - 所有数据保存在 U盘，换电脑不丢失
- ✅ **隐私保护** - 关闭时自动清除本地痕迹

---

## 📦 包含内容

```
openclaw-portable/
├── node/              ← Node.js 22.14.0 (预置，192MB)
├── npm-global/        ← OpenClaw 2026.3.12 (预置，487MB)
│   └── lib/node_modules/openclaw/
├── start.bat          ← Windows 一键启动
├── stop.bat           ← Windows 一键关闭
├── start.sh           ← Linux/WSL2 启动脚本
├── stop.sh            ← Linux/WSL2 关闭脚本
├── config/            ← 配置目录
├── workspace/         ← 工作目录
└── data/              ← 数据存储（自动创建）
```

**总大小：**
- 压缩包：157MB
- 解压后：679MB

---

## 🚀 使用方法

### Windows 用户

**推荐：智能启动（自动检测 U盘）**
1. **解压到 U盘**（约 1 分钟）
2. **双击 `start.bat`**（首次约 30 秒）
   - ✅ 自动检测 U盘盘符
   - ✅ 多 U盘时可选择
   - ✅ 记住上次路径
3. **访问 http://localhost:3000**
4. **使用完毕后，双击 `stop.bat`**

**备用：基础启动（手动指定路径）**
- 如智能版遇到问题，可使用 `start-basic.bat`

### Linux/macOS 用户

**推荐：智能启动（自动检测 U盘）**
```bash
# 解压
tar -xzf openclaw-portable.tar.gz

# 启动（自动检测 U盘）
cd /media/$(whoami)/*/openclaw-portable
./start.sh

# 关闭
./stop.sh
```

**备用：基础启动（手动指定路径）**
```bash
# 如智能版遇到问题
./start-basic.sh /path/to/usb
```

---

## 📊 与传统安装对比

| 项目 | 传统安装 | 便携版（预置全部） |
|------|---------|-------------------|
| **首次安装时间** | 10-30 分钟 | 1-2 分钟 |
| **需要网络** | ✅ 必须 | ❌ **不需要** |
| **下载大小** | ~500MB | 0 |
| **换电脑使用** | ❌ 需重装 | ✅ 即插即用 |
| **数据同步** | ❌ 手动 | ✅ 自动 |
| **隐私保护** | ❌ 有痕迹 | ✅ 无痕迹 |
| **国内用户体验** | 需要翻墙或镜像 | **完美** |

---

## 💡 工作原理

### 启动流程

```
start.bat / start.sh
    ↓
检测 U盘中的 Node.js
    ↓
设置 PATH 环境变量
    ↓
检测 U盘中的 OpenClaw
    ↓
设置 PATH 环境变量
    ↓
检测并安装 Git（如需要，仅此一项需要网络）
    ↓
从 U盘加载配置
    ↓
启动 OpenClaw Gateway
    ↓
✅ 访问 http://localhost:3000
```

### 关闭流程

```
stop.bat / stop.sh
    ↓
停止 OpenClaw Gateway
    ↓
保存数据到 U盘
    ↓
清理本地临时文件
    ↓
清除本地痕迹
    ↓
✅ 安全拔出 U盘
```

---

## 📋 系统要求

| 平台 | 要求 |
|------|------|
| **Windows** | Windows 10 2004+ 或 Windows 11 |
| **WSL2** | Ubuntu 20.04+（首次会自动安装） |
| **Linux** | Ubuntu 20.04+ / Debian 11+ |
| **macOS** | macOS 10.15+ |
| **U盘** | 至少 1GB 可用空间 |

---

## ❓ 常见问题

### Q: 为什么这么大？

A: 包含了完整的运行环境：
- Node.js 运行时（192MB）
- OpenClaw 及其依赖（487MB）
- 这是完全离线运行的代价

### Q: 能在公司电脑用吗？

A: 可以！所有数据都在 U盘，关闭后本地不留痕迹。

### Q: Git 为什么还需要网络？

A: Git 用于版本控制，通常系统已安装。如果未安装，脚本会自动安装（需要网络）。这是唯一需要网络的步骤。

### Q: 能在无网络环境使用吗？

A: 几乎可以！只要系统已安装 Git，就完全不需要网络。

### Q: 如何更新 OpenClaw？

A: 在有网络的环境中运行：
```bash
export PATH="$PWD/node/bin:$PATH"
npm install -g openclaw@latest
```

### Q: Node.js 会过期吗？

A: Node.js 版本会更新，但基本功能稳定。建议每 6-12 个月更新一次。

---

## 🔄 更新便携包

```bash
# 在有网络的机器上运行
cd openclaw-portable

# 更新 Node.js（可选）
rm -rf node
curl -L -o node.tar.xz https://npmmirror.com/mirrors/node/v22.14.0/node-v22.14.0-linux-x64.tar.xz
tar -xf node.tar.xz
mv node-v22.14.0-linux-x64 node
rm node.tar.xz

# 更新 OpenClaw
export PATH="$PWD/node/bin:$PWD/npm-global/bin:$PATH"
npm install -g openclaw@latest
```

---

## 📥 下载

- **GitHub Release**: https://github.com/SonicBotMan/openclaw-portable/releases
- **镜像下载**: https://npmmirror.com/mirrors/openclaw-portable/

---

## 🎯 适用场景

| 场景 | 是否适合 |
|------|---------|
| **公司电脑** | ✅ 完美（无痕迹） |
| **网吧/公共电脑** | ✅ 完美（即插即用） |
| **无网络环境** | ✅ 几乎完美（仅 Git 需要网络） |
| **多台电脑切换** | ✅ 完美（数据同步） |
| **国内网络环境** | ✅ 完美（无需翻墙） |

---

**版本：** 4.0.0 (完全离线版)
**更新日期：** 2026-03-14
**Node.js 版本：** v22.14.0
**OpenClaw 版本：** 2026.3.12
**压缩包大小：** 157MB
**解压后大小：** 679MB
