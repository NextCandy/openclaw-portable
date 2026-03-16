# 🚀 OpenClaw 便携版 v6.0

### 全球首个真正零门槛的 AI 助手 - 无需网络即可运行

**中文** | [English](README.md) | [日本語](README_JP.md)

---

## 🎉 v6.0 新功能

### **内置本地模型支持** 🤖

OpenClaw 便携版现在包含一个 **CPU 本地 AI 模型**（Qwen2.5-1.5B），完全离线运行：

- ✅ **零 API 成本** - 无需外部 API
- ✅ **完全离线** - 无需网络即可使用
- ✅ **零配置** - 自动检测和注册
- ✅ **优雅降级** - 云端 API 作为备用

详见 [BUNDLED_MODEL.md](BUNDLED_MODEL.md)。

---

## 🎯 我们解决的问题

**传统 AI 助手的困境：**
- ❌ 安装困难（10-30分钟，各种依赖）
- ❌ 需要稳定的网络（VPN 经常不稳定）
- ❌ 切换设备时需要重新安装
- ❌ 数据分散在各台机器上
- ❌ 新用户学习成本高

**结果？** 挫败感、浪费时间、隐私担忧。

---

## 💡 我们的解决方案：OpenClaw 便携版 v6.0

**第一个真正开箱即用的 AI 助手：**

### ✨ 核心特性

| 特性 | 说明 |
|------|------|
| **🔌 完全离线运行** | 首次下载后无需网络 |
| **⚡ 一键启动** | 双击 `start.bat`，等待 60 秒，完成 |
| **💾 便携设计** | 从 U 盘运行，数据随你而行 |
| **🔒 零痕迹** | 完美支持共享/公共电脑 |
| **🔄 自动同步** | 数据跟随你，而不是机器 |
| **🛡️ 企业级安全** | 自动配置权限，模板化管理 |
| **🧠 智能启动** | 智能等待 60 秒，实时进度反馈 |
| **🌐 自动打开浏览器** | Token 自动提取，浏览器自动打开 |
| **📝 零配置** | 解压即用，无需任何设置 |

**一个 U 盘，一次点击，零烦恼。**

---

## 🌟 为什么 OpenClaw 便携版 v6.0 独一无二

| 特性 | 传统 AI | OpenClaw 便携版 v6.0 |
|------|---------|-------------------|
| **安装时间** | 10-30 分钟 | **60 秒** |
| **网络需求** | 总是 | **仅首次** |
| **VPN 需求** | 需要（受限网络） | **不需要** |
| **设备切换** | 需要重装 | **插上 U 盘即可** |
| **公共电脑隐私** | 会留下痕迹 | **零痕迹** |
| **数据同步** | 手动 | **自动** |
| **配置复杂度** | 复杂设置 | **零配置** |
| **Token 管理** | 手动查找 | **自动提取** |

---

## 🎭 完美适用场景

### 🏢 企业环境
- **问题：** 无法安装软件，网络被监控
- **解决方案：** 从 U 盘运行，不留任何痕迹
- **结果：** 无需 IT 审批即可使用 AI 助手

### 🌐 受限网络（中国、伊朗等）
- **问题：** VPN 不稳定，下载速度慢
- **解决方案：** 所有依赖预装，无需下载
- **结果：** 无需 VPN 即可完美体验

### ☕ 公共电脑（网吧、图书馆）
- **问题：** 不能安装软件，担心数据安全
- **解决方案：** 便携运行，数据在 U 盘上
- **结果：** 在共享设备上安全使用 AI

### 💼 多设备办公
- **问题：** 每台机器都要重新安装
- **解决方案：** 一个 U 盘，所有设备通用
- **结果：** 无缝工作流，随时随地

### 🏔️ 偏远/离线地区
- **问题：** 没有网络，无法使用 AI
- **解决方案：** 99% 离线运行
- **结果：** 在野外也能使用 AI 助手

---

## 🚀 快速开始（60 秒）

### Windows 用户
```powershell
1. 下载离线包（148 MB）
2. 解压到任意文件夹
3. 双击 start.bat
4. 等待最多 60 秒
5. 浏览器自动打开 http://localhost:18789
6. 完成！🎉
```

### Linux/macOS 用户
```bash
# 解压
tar -xzf OpenClaw-Portable-v6.0.0-*.tar.gz

# 启动
cd OpenClaw-Portable-v6.0.0
./start.sh

# 浏览器会自动打开
```

**就这么简单！无需安装，无需配置，无需网络。**

---

## 📦 包含内容

### Windows 离线包（148 MB）
```
OpenClaw-Portable-v6.0.0-windows/
├── node/              ← Node.js 22.16.0（预装）
├── openclaw-pkg/      ← OpenClaw latest（预装）
├── start.bat          ← 一键启动
├── stop.bat           ← 一键停止并清理
├── check.bat          ← 环境检查
├── config/            ← 配置模板
│   └── openclaw.json.example
└── workspace/         ← 你的工作区（自动创建）
```

### 已包含功能
- ✅ **Node.js 22.16.0** - 完整运行时预装
- ✅ **OpenClaw latest** - 所有依赖已包含
- ✅ **智能启动脚本** - 自动检测、自动等待、自动启动
- ✅ **配置模板** - 轻松自定义
- ✅ **零网络依赖** - 完全离线运行

---

## 🔧 高级用法

### 自定义端口
编辑 `start.bat`，修改：
```batch
set GATEWAY_PORT=18789
```

### 自定义配置
1. 复制 `config/openclaw.json.example` 为 `config/openclaw.json`
2. 编辑配置文件
3. 重启 OpenClaw

### 环境变量（Linux/macOS）
```bash
export GATEWAY_PORT=18790
./start.sh
```

---

## ❓ 常见问题

### Q: 为什么下载包这么大（148 MB）？
**A:** 包含完整运行时：
- Node.js 运行时（~85 MB）
- OpenClaw + 所有依赖（~63 MB）
- 这是真正离线运行的代价

### Q: 可以在公司电脑上使用吗？
**A:** 可以！所有数据都在 U 盘上，本地机器零痕迹。

### Q: 在中国能正常使用吗？
**A:** 完美运行！无需 VPN，所有内容已预下载。

### Q: 如果启动超过 60 秒怎么办？
**A:** 首次启动可能需要更长时间。脚本会继续等待并每 5 秒显示进度。

### Q: 在哪里找到 Token？
**A:** Token 会自动提取并显示在控制台中。浏览器会自动打开带有 Token 的 URL。

---

## 📊 版本历史

| 版本 | 日期 | 类型 | 亮点 |
|------|------|------|------|
| **v6.0.0** | 2026-03-15 | 🎉 里程碑 | 完全重写，零配置，完美支持非技术用户 |
| v5.0.5 | 2026-03-15 | 🐛 Bug 修复 | 改进启动超时（60秒），更好的 Token 提取 |
| v5.0.4 | 2026-03-15 | 🐛 Bug 修复 | 修复 Windows 批处理脚本语法错误 |
| v5.0.3 | 2026-03-15 | ✨ 新功能 | 自动提取和显示 Token |
| v5.0.2 | 2026-03-15 | 🐛 Bug 修复 | 修复端口传递问题 |
| v5.0.0 | 2026-03-14 | 🎉 初始版本 | 完全离线运行，多平台支持 |

---

## 📥 下载

### 最新版本：v6.0.0

**Windows 离线包：**
- **大小：** 148.61 MB
- **下载：** https://github.com/SonicBotMan/openclaw-portable/releases/tag/v6.0.0

**Linux/macOS：**
- 克隆仓库
- 运行 `./install.sh`（仅首次，需要网络）
- 运行 `./start.sh`（后续完全离线）

---

## 📖 文档

| 文档 | 说明 |
|------|------|
| [README.md](README.md) | English Documentation |
| [README_JP.md](README_JP.md) | 日本語ドキュメント |
| [CHANGELOG.md](CHANGELOG.md) | 版本历史 |
| [INSTALL.md](INSTALL.md) | 安装指南 |
| [QUICK-START.md](QUICK-START.md) | 快速开始 |
| [OFFLINE-GUIDE.md](OFFLINE-GUIDE.md) | 离线使用指南 |

---

## 🤝 贡献

欢迎贡献！详见 [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE)

---

## 🌟 Star 历史

如果这个项目对你有帮助，请 ⭐️ Star！

![Star History Chart](https://api.star-history.com/svg?repos=SonicBotMan/openclaw-portable&type=Date)

---

**版本：** 6.0.0 | **发布日期：** 2026-03-15 | **Node.js：** v22.16.0 | **OpenClaw：** latest

---

<p align="center">
  <b>用 ❤️ 为全球 AI 社区打造</b>
</p>

<p align="center">
  <a href="https://github.com/SonicBotMan/openclaw-portable">GitHub</a> •
  <a href="https://github.com/SonicBotMan/openclaw-portable/releases">下载</a> •
  <a href="https://github.com/SonicBotMan/openclaw-portable/issues">报告 Bug</a> •
  <a href="https://github.com/SonicBotMan/openclaw-portable/issues">功能建议</a>
</p>
