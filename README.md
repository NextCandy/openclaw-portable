# 🚀 OpenClaw Portable

### The World's First Truly Offline AI Assistant - Zero Network Required

[中文](README_CN.md) | **English** | [日本語](README_JP.md)

---

## 🎯 The Problem We Solve

**Traditional AI assistants require:**
- ❌ 10-30 minutes installation
- ❌ Stable internet connection
- ❌ VPN in restricted regions
- ❌ Reinstall on every new device
- ❌ Data scattered across machines

**The result?** Frustration, wasted time, and privacy concerns.

---

## 💡 Our Solution: OpenClaw Portable

**The first AI assistant that:**
- ✅ **Works completely offline** - No network needed after extraction
- ✅ **Installs in 60 seconds** - Just extract and run
- ✅ **Runs from USB** - Your AI, your data, everywhere
- ✅ **Leaves zero traces** - Perfect for shared/public computers
- ✅ **Syncs automatically** - Data follows you, not the machine

**One USB. One click. Zero hassle.**

---

## 🌟 Why OpenClaw Portable is Unique

| Feature | Traditional AI | OpenClaw Portable |
|---------|---------------|-------------------|
| **Installation** | 10-30 min | **60 seconds** |
| **Network Required** | Always | **Never** |
| **VPN Needed (China)** | Yes | **No** |
| **Switch Devices** | Reinstall | **Just plug** |
| **Privacy** | Traces left | **Zero traces** |
| **Data Sync** | Manual | **Automatic** |

---

## 🎭 Perfect For These Scenarios

### 🏢 Corporate Environment
- **Problem:** Can't install software, monitored network
- **Solution:** Run from USB, leave no traces
- **Result:** Use AI assistant without IT approval

### 🌐 Restricted Networks (China, Iran, etc.)
- **Problem:** VPN unstable, slow downloads
- **Solution:** Everything pre-installed, no downloads
- **Result:** Perfect experience without VPN

### ☕ Public Computers (Cyber Cafes, Libraries)
- **Problem:** Can't install, data security concerns
- **Solution:** Portable, auto-clean on exit
- **Result:** Your AI, your privacy

### 💼 Multiple Workstations
- **Problem:** Reinstall on every machine
- **Solution:** One USB, all machines
- **Result:** Seamless workflow anywhere

### 🏔️ Remote/Offline Locations
- **Problem:** No internet, can't use AI
- **Solution:** 99% offline (only Git needs network once)
- **Result:** AI assistant in the wilderness

---

## 🚀 Quick Start (60 Seconds)

### Windows
```powershell
1. Extract to USB (1 min)
2. Double-click start.bat
3. Open http://localhost:3000
4. Done! 🎉
```

### Linux/macOS
```bash
# Extract
tar -xzf openclaw-portable.tar.gz

# Start
cd openclaw-portable
./start.sh

# Open browser
http://localhost:3000
```

**That's it. No installation. No configuration. No network.**

---

## 📦 What's Inside

```
openclaw-portable/
├── node/              ← Node.js 22.14.0 (Pre-installed, 192MB)
├── npm-global/        ← OpenClaw 2026.3.12 (Pre-installed, 487MB)
├── start.bat/.sh      ← One-click start
├── stop.bat/.sh       ← One-click stop & clean
├── config/            ← Your configurations
├── workspace/         ← Your workspace
└── data/              ← Your data (auto-created)
```

**Total Size:**
- Download: 157MB (compressed)
- Extracted: 679MB

---

## 🔒 Security & Privacy

### Automatic Protection
- ✅ Config files: `chmod 600` (owner only)
- ✅ Log files: `chmod 640` (owner + group read)
- ✅ Auto-clean on exit (zero traces)
- ✅ Data stays on USB (never on local disk)

### ⚠️ Never Share These Files
- `config/openclaw.json` - Contains API keys
- `data/.last_usb` - Contains path info

---

## 📊 Comparison: Portable vs Traditional Install

### Traditional OpenClaw Installation

**The Pain:**
```bash
# Step 1: Install Node.js (10-15 min)
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Step 2: Install OpenClaw (5-10 min)
npm install -g openclaw

# Step 3: Configure (5-10 min)
openclaw config init
# Edit config files...

# Step 4: Repeat on every new device!
```

**Problems:**
- ❌ Requires stable internet (500MB+ download)
- ❌ VPN needed in restricted regions
- ❌ Reinstall on every new machine
- ❌ Data scattered across devices
- ❌ Traces left on shared computers
- ❌ 10-30 minutes setup time

### OpenClaw Portable

**The Solution:**
```bash
# Step 1: Extract (1 min)
unzip OpenClaw-Portable-v4.1.0.zip

# Step 2: Run (30s)
./start.sh

# Done! 🎉
```

**Benefits:**
- ✅ Zero downloads (everything pre-installed)
- ✅ Works offline (99% of the time)
- ✅ USB portability (your AI everywhere)
- ✅ Data syncs automatically
- ✅ Zero traces on exit
- ✅ 60 seconds to start

### Side-by-Side Comparison

| Feature | Traditional Install | OpenClaw Portable |
|---------|-------------------|-------------------|
| **Setup Time** | 10-30 minutes | **60 seconds** |
| **Network Required** | ✅ Yes (500MB+ download) | ❌ **No** |
| **VPN Needed (China)** | ✅ Yes | ❌ **No** |
| **Switch Devices** | ❌ Reinstall every time | ✅ **Just plug USB** |
| **Data Portability** | ❌ Manual sync | ✅ **Automatic** |
| **Privacy (Shared PC)** | ❌ Traces left | ✅ **Zero traces** |
| **Config Persistence** | ❌ Per-device | ✅ **USB-based** |
| **Node.js Install** | ✅ Required | ❌ **Pre-installed** |
| **OpenClaw Install** | ✅ Required | ❌ **Pre-installed** |
| **Offline Usage** | ❌ No | ✅ **99% offline** |

**The Verdict:** OpenClaw Portable eliminates all the friction of traditional installation while adding portability and privacy.

---

## 🎯 Use Cases

### For Developers
- AI coding assistant on any machine
- No VPN needed in China
- Code with AI at client sites

### For Researchers
- AI research in offline labs
- Analyze sensitive data locally
- Work from field locations

### For Students
- AI tutor on library computers
- Study offline in dorms
- Share USB with classmates

### For Remote Workers
- AI assistant while traveling
- Work from cafes/hotels
- Switch between home/office

---

## 📥 Download

### Latest Release: v4.1.0
- **GitHub:** https://github.com/SonicBotMan/openclaw-portable/releases
- **Mirror (China):** https://npmmirror.com/mirrors/openclaw-portable/

### System Requirements
| Platform | Requirement |
|----------|-------------|
| **Windows** | Windows 10 2004+ or Windows 11 |
| **Linux** | Ubuntu 20.04+ / Debian 11+ |
| **macOS** | macOS 10.15+ |
| **USB Drive** | Minimum 1GB free space |

---

## 🔧 Advanced Usage

### Update OpenClaw (Requires Network)
```bash
cd openclaw-portable
export PATH="$PWD/node/bin:$PWD/npm-global/bin:$PATH"
npm install -g openclaw@latest
```

### Custom Configuration
```bash
# Edit config file
nano config/openclaw.json

# Or use environment variables
export OPENCLAW_API_KEY="your-key"
```

---

## ❓ FAQ

### Q: Why is it so large (679MB)?
**A:** It includes the complete runtime:
- Node.js runtime (192MB)
- OpenClaw + dependencies (487MB)
- This is the price of true offline capability

### Q: Can I use it on corporate computers?
**A:** Yes! All data stays on USB, zero traces on local machine.

### Q: Does it work in China?
**A:** Perfectly! No VPN needed, everything pre-downloaded.

### Q: How to update?
**A:** Run `npm install -g openclaw@latest` once in a networked environment.

### Q: Is my data safe?
**A:** Yes! Data never leaves your USB. Auto-clean on exit.

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 License

MIT License - See [LICENSE](LICENSE)

---

## 🌟 Star History

If this project helps you, please ⭐️ star it!

[![Star History Chart](https://api.star-history.com/svg?repos=SonicBotMan/openclaw-portable&type=Date)](https://star-history.com/#SonicBotMan/openclaw-portable&Date)

---

**Version:** 4.1.0 | **Release Date:** 2026-03-14 | **Node.js:** v22.14.0 | **OpenClaw:** 2026.3.12

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
