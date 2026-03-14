# OpenClaw Portable - 安装说明

## 🎯 三步上手

### 步骤 1: 解压到 U盘

```bash
# Linux/macOS
tar -xzf openclaw-portable.tar.gz -C /media/usb/

# Windows (使用 7-Zip 或 WinRAR)
右键 → 解压到U盘
```

### 步骤 2: 启动

**Windows 用户:**
```
双击 start.bat
```

**Linux/macOS 用户:**
```bash
chmod +x start.sh
./start.sh
```

### 步骤 3: 访问

浏览器打开: http://localhost:3000

---

## 📦 已包含内容

- ✅ **Node.js 20.11.0** - 无需下载
- ✅ **启动/关闭脚本** - 一键操作
- ✅ **完整文档** - README.md

---

## 🔧 首次使用

首次启动时，脚本会自动：
1. 检测 U盘中的 Node.js
2. 安装 Git（如果缺失）
3. 安装 OpenClaw（如果缺失）
4. 创建配置文件

---

## 🌐 国内用户

**好消息：** Node.js 已预置，无需下载！

首次安装 Git 和 OpenClaw 时，会自动使用国内镜像加速。

---

## ❓ 常见问题

### Q: 启动失败怎么办？

A: 确保：
1. WSL2 已安装（Windows 用户）
2. U盘路径正确
3. 运行 `check.bat` 检查环境

### Q: 如何更新 Node.js？

A: 下载新版本的 Node.js，替换 `node/` 目录即可。

---

**需要帮助？** 查看完整文档: [README.md](README.md)
