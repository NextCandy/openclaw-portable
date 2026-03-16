# 🚀 OpenClaw Portable

### The World's First Truly Offline AI Assistant - Zero Network Required

[中文](README_CN.md) | **English** | [日本語](README_JP.md)

---

## 📦 Two Versions Available

Choose the version that fits your needs:

| Version | Size | Model | Best For |
|---------|------|-------|----------|
| **Offline** | ~1.2 GB | ✅ Built-in Qwen2.5-1.5B | Complete offline use, no setup |
| **Online** | ~300 MB | ❌ None (add your own) | Fast download, use cloud APIs |

### Offline Version (Recommended)
- ✅ **Complete offline operation** - No network needed after download
- ✅ **Built-in Qwen2.5-1.5B model** - Zero API costs
- ✅ **Works out of the box** - Just extract and run
- 📥 **Download**: `OpenClaw-Portable-v6.0.0-windows-offline.tar.gz`

### Online Version
- ⚡ **Smaller download** - 4x faster to download
- 🌐 **Use cloud APIs** - DeepSeek, OpenAI, etc.
- 🤖 **Add your own model** - Support for custom models
- 📥 **Download**: `OpenClaw-Portable-v6.0.0-windows-online.tar.gz`

**Recommendation**: Choose **Offline** version if you want complete offline operation. Choose **Online** version if you have stable internet or want to use specific cloud APIs.

---

## 🎉 What's New in v6.0

### **Built-in Local Model Support** 🤖

OpenClaw Portable now includes a **CPU-only local AI model** (Qwen2.5-1.5B) that runs entirely offline:

- ✅ **Zero API costs** - No external API needed
- ✅ **Complete offline** - Works without internet
- ✅ **Zero configuration** - Auto-detected and registered
- ✅ **Graceful degradation** - Cloud APIs still available as fallback

See [BUNDLED_MODEL.md](BUNDLED_MODEL.md) for details.

---

## 🎯 The Problem We Solve

**Traditional AI assistants require:**
- ❌ 10-30 minutes installation with complex dependencies
- ❌ Stable internet connection (VPN often needed)
- ❌ Reinstallation when switching devices
- ❌ Data scattered across multiple machines
- ❌ Steep learning curve for new users

**The result?** Frustration, wasted time, and privacy concerns.

---

## 💡 Our Solution: OpenClaw Portable v6.0

**The first AI assistant that truly works out of the box:**

### ✨ Core Features

| Feature | Description |
|---------|-------------|
| **🔌 Completely Offline** | No network needed after first download |
| **⚡ One-Click Start** | Double-click `start.bat`, wait 60s, done |
| **💾 Portable Design** | Run from USB, your data travels with you |
| **🔒 Zero Traces** | Perfect for shared/public computers |
| **🔄 Auto Sync** | Data follows you, not the machine |
| **🛡️ Enterprise Security** | Auto-configured permissions, template-based |
| **🧠 Smart Startup** | Intelligent 60s wait with progress feedback |
| **🌐 Auto Browser Launch** | Token auto-extracted, browser opens automatically |
| **📝 Zero Configuration** | Extract and run, no setup required |

**One USB. One click. Zero hassle.**

---

## 🌟 Why OpenClaw Portable v6.0 is Unique

| Feature | Traditional AI | OpenClaw Portable v6.0 |
|---------|---------------|-------------------|
| **Installation Time** | 10-30 min | **60 seconds** |
| **Network Required** | Always | **Only first time** |
| **VPN Needed** | Yes (in restricted regions) | **No** |
| **Device Switching** | Reinstall required | **Just plug USB** |
| **Privacy on Shared PCs** | Traces left behind | **Zero traces** |
| **Data Sync** | Manual | **Automatic** |
| **Configuration** | Complex setup | **Zero config** |
| **Token Management** | Manual lookup | **Auto-extracted** |

---

## 🎭 Perfect For These Scenarios

### 🏢 Corporate Environment
- **Problem:** Can't install software, monitored network
- **Solution:** Run from USB, leave no traces
- **Result:** Use AI assistant without IT approval

### 🌐 Restricted Networks (China, Iran, etc.)
- **Problem:** VPN unstable, slow downloads
- **Solution:** Everything pre-installed, no downloads needed
- **Result:** Perfect experience without VPN

### ☕ Public Computers (Libraries, Cafes)
- **Problem:** Can't install, data security concerns
- **Solution:** Portable, auto-clean on exit
- **Result:** Your AI, your privacy

### 💼 Multiple Workstations
- **Problem:** Reinstall on every machine
- **Solution:** One USB for all machines
- **Result:** Seamless workflow anywhere

### 🏔️ Remote/Offline Locations
- **Problem:** No internet, can't use AI
- **Solution:** 99% offline operation after first setup
- **Result:** AI assistant in the wilderness

---

## 🚀 Quick Start (60 Seconds)

### Windows
```powershell
1. Download offline package (148 MB)
2. Extract to any folder
3. Double-click start.bat
4. Wait up to 60 seconds
5. Browser opens automatically at http://localhost:18789
6. Done! 🎉
```

### Linux/macOS
```bash
# Extract
tar -xzf OpenClaw-Portable-v6.0.0-*.tar.gz

# Start
cd OpenClaw-Portable-v6.0.0-windows
./start.sh

# Browser opens automatically
```

**That's it! No installation, no configuration, no network.**

---

## 📦 What's Inside

### Windows Offline Package (148 MB)
```
OpenClaw-Portable-v6.0.0-windows/
├── node/              ← Node.js 22.16.0 (Pre-installed)
├── openclaw-pkg/      ← OpenClaw latest (Pre-installed)
├── start.bat          ← One-click start
├── stop.bat           ← One-click stop & clean
├── check.bat          ← Environment check
├── config/            ← Configuration templates
│   └── openclaw.json.example
└── workspace/         ← Your workspace (auto-created)
```

### Features Included
- ✅ **Node.js 22.16.0** - Complete runtime pre-installed
- ✅ **OpenClaw latest** - All dependencies included
- ✅ **Smart startup scripts** - Auto-detect, auto-wait, auto-launch
- ✅ **Configuration templates** - Easy customization
- ✅ **Zero network dependency** - Works completely offline

---

## 🔧 Advanced Usage

### Custom Port
Edit `start.bat` and change:
```batch
set GATEWAY_PORT=18789
```

### Custom Configuration
1. Copy `config/openclaw.json.example` to `config/openclaw.json`
2. Edit the configuration
3. Restart OpenClaw

### Environment Variables (Linux/macOS)
```bash
export GATEWAY_PORT=18790
./start.sh
```

---

## ❓ FAQ

### Q: Why is the download so large (148 MB)?
**A:** It includes the complete runtime:
- Node.js runtime (~85 MB)
- OpenClaw + all dependencies (~63 MB)
- This is the price of true offline capability

### Q: Can I use it on corporate computers?
**A:** Yes! All data stays on USB, zero traces on local machine.

### Q: Does it work in China?
**A:** Perfectly! No VPN needed, everything pre-downloaded.

### Q: What if startup takes more than 60 seconds?
**A:** First-time startup may take longer. The script will continue waiting and show progress every 5 seconds.

### Q: Where can I find my token?
**A:** Token is automatically extracted and displayed in the console. Browser opens with token in URL.

---

## 📊 Version History

| Version | Date | Type | Highlights |
|---------|------|------|------------|
| **v6.0.0** | 2026-03-15 | 🎉 Milestone | Complete rewrite, zero-config, perfect for non-technical users |
| v5.0.5 | 2026-03-15 | 🐛 Bug Fix | Improved startup timeout (60s), better token extraction |
| v5.0.4 | 2026-03-15 | 🐛 Bug Fix | Fixed Windows batch script syntax errors |
| v5.0.3 | 2026-03-15 | ✨ Feature | Auto-extract and display token, browser auto-launch |
| v5.0.2 | 2026-03-15 | 🐛 Bug Fix | Fixed port passing in startup scripts |
| v5.0.0 | 2026-03-14 | 🎉 Initial | First release, completely offline operation |

---

## 📥 Download

### Latest Release: v6.0.0

**Windows Offline Package:**
- **Size:** 148.61 MB
- **Download:** https://github.com/SonicBotMan/openclaw-portable/releases/tag/v6.0.0

**Linux/macOS:**
- Clone the repository
- Run `./install.sh` (first time only, requires network)
- Run `./start.sh` (subsequent runs are completely offline)

---

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [README_CN.md](README_CN.md) | 中文文档 |
| [README_JP.md](README_JP.md) | 日本語ドキュメント |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [INSTALL.md](INSTALL.md) | Installation guide |
| [QUICK-START.md](QUICK-START.md) | Quick start guide |
| [OFFLINE-GUIDE.md](OFFLINE-GUIDE.md) | Offline usage guide |

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 License

MIT License - See [LICENSE](LICENSE)

---

## 🌟 Star History

If this project helps you, please ⭐️ star it!

<<<<<<< HEAD
![Star History Chart](https://api.star-history.com/svg?repos=SonicBotMan/openclaw-portable&type=Date)
=======
[![GitHub stars](https://img.shields.io/github/stars/SonicBotMan/openclaw-portable?style=for-the-badge&logo=github&color=yellow)](https://github.com/SonicBotMan/openclaw-portable/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/SonicBotMan/openclaw-portable?style=for-the-badge&logo=github&color=blue)](https://github.com/SonicBotMan/openclaw-portable/network/members)

<details>
<summary>📊 View Star History Chart</summary>

[![Star History Chart](https://api.star-history.com/svg?repos=SonicBotMan/openclaw-portable&type=Date)](https://star-history.com/#SonicBotMan/openclaw-portable&Date)
>>>>>>> 896d1b6 (fix: improve Star History display with real-time badges)

<i>Note: The chart above may take 24-48 hours to update due to GitHub's image cache. Click to view real-time data on Star History website.</i>

</details>

---

**Version:** 6.0.0 | **Release Date:** 2026-03-15 | **Node.js:** v22.16.0 | **OpenClaw:** latest

---

<p align="center">
  <b>Made with ❤️ for the global AI community</b>
</p>

<p align="center">
  <a href="https://github.com/SonicBotMan/openclaw-portable">GitHub</a> •
  <a href="https://github.com/SonicBotMan/openclaw-portable/releases">Download</a> •
  <a href="https://github.com/SonicBotMan/openclaw-portable/issues">Report Bug</a> •
  <a href="https://github.com/SonicBotMan/openclaw-portable/issues">Request Feature</a>
</p>
