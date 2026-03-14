# OpenClaw Portable - 小白使用指南

> **完全离线，无需网络，1分钟上手！**

---

## 📋 准备工作

### 你需要：
- ✅ **一个 U盘**（至少 1GB 空间）
- ✅ **一台电脑**（Windows 10+ 或 Linux）
- ✅ **5 分钟时间**

### 你不需要：
- ❌ 不需要网络（完全离线）
- ❌ 不需要安装任何软件
- ❌ 不需要懂编程

---

## 🚀 第一步：下载和解压

### 1.1 下载

**方法一：GitHub（推荐）**
1. 打开这个链接：https://github.com/SonicBotMan/openclaw-portable/releases
2. 找到 **v4.0.0**
3. 点击 **openclaw-portable.tar.gz**（157MB）
4. 等待下载完成

**方法二：国内镜像（如果 GitHub 慢）**
- 百度网盘：[待补充]
- 阿里云 OSS：[待补充]

### 1.2 解压到 U盘

**Windows 用户：**
1. 把 U盘插入电脑
2. 找到下载的 `openclaw-portable.tar.gz`
3. 右键 → 解压到 U盘根目录
4. 解压后会看到 `openclaw-portable` 文件夹

**Linux/macOS 用户：**
```bash
# 插入 U盘后
cd /media/你的用户名/U盘名称
tar -xzf ~/Downloads/openclaw-portable.tar.gz
```

---

## 🎯 第二步：启动 OpenClaw

### Windows 用户

**方法一：双击启动（推荐）**
1. 打开 U盘
2. 进入 `openclaw-portable` 文件夹
3. 双击 `start.bat`
4. 等待 10-30 秒
5. 自动打开浏览器，访问 http://localhost:3000

**方法二：命令行启动**
1. 按 `Win + R`，输入 `cmd`
2. 输入：
   ```cmd
   U:
   cd openclaw-portable
   start.bat
   ```

### Linux/macOS 用户

**方法一：双击启动**
1. 打开终端
2. 输入：
   ```bash
   cd /media/你的用户名/U盘名称/openclaw-portable
   ./start.sh
   ```

**方法二：文件管理器**
1. 打开文件管理器
2. 进入 `openclaw-portable` 文件夹
3. 右键 `start.sh` → 属性 → 权限 → 勾选"允许作为程序执行"
4. 双击 `start.sh`

---

## ✅ 第三步：验证是否成功

### 3.1 检查启动成功

**看到以下信息表示成功：**
```
✅ OpenClaw 启动成功！
📍 访问地址：http://localhost:3000
```

### 3.2 访问 Web 界面

1. 打开浏览器（Chrome、Firefox、Edge 都可以）
2. 输入地址：`http://localhost:3000`
3. 看到欢迎页面 = 成功！

---

## 💾 第四步：保存数据

### 4.1 数据自动保存

**所有数据自动保存在 U盘：**
- ✅ 配置文件：`openclaw-portable/config/`
- ✅ 工作目录：`openclaw-portable/workspace/`
- ✅ 日志文件：`openclaw-portable/logs/`

**换电脑使用：**
- 所有数据都在 U盘
- 换电脑插上 U盘就能用
- 不会丢失任何数据

---

## 🔒 第五步：关闭 OpenClaw

### Windows 用户

**方法一：双击关闭（推荐）**
1. 双击 `stop.bat`
2. 等待 5-10 秒
3. 看到 "✅ OpenClaw 已关闭" = 成功

**方法二：命令行关闭**
```cmd
U:
cd openclaw-portable
stop.bat
```

### Linux/macOS 用户

```bash
cd /media/你的用户名/U盘名称/openclaw-portable
./stop.sh
```

### 重要提示

**关闭后会自动清理：**
- ✅ 清理临时文件
- ✅ 清理日志缓存
- ✅ 不在电脑上留下任何痕迹

---

## 🎓 常见问题

### Q1: 启动失败怎么办？

**可能原因：**
1. **端口被占用** - 检查 3000 端口是否被占用
   ```bash
   # Linux/macOS
   lsof -i :3000
   
   # Windows
   netstat -ano | findstr :3000
   ```
2. **权限不足** - 右键 `start.sh` → 以管理员身份运行

### Q2: 浏览器打不开？

**解决方法：**
1. 检查是否启动成功（看终端输出）
2. 手动输入地址：`http://localhost:3000`
3. 换一个浏览器试试

### Q3: U盘满了怎么办？

**解决方法：**
1. 删除 `logs/` 目录中的旧日志
2. 清理 `workspace/` 中的临时文件
3. 最少需要 1GB 空间

### Q4: 换电脑后数据还在吗？

**答案：** ✅ 在！
- 所有数据都在 U盘
- 换电脑后插上 U盘就能用
- 配置、历史记录都在

### Q5: 需要网络吗？

**答案：** ❌ 不需要！
- 完全离线运行
- Node.js 和 OpenClaw 都预置了
- 唯一需要网络的是 Git（如果没安装的话）

---

## 🎯 进阶使用

### 1. 配置文件

**位置：** `openclaw-portable/config/openclaw.json`

**修改配置：**
1. 用记事本打开 `openclaw.json`
2. 修改配置
3. 重启 OpenClaw

### 2. 工作目录

**位置：** `openclaw-portable/workspace/`

**用途：**
- 存放项目文件
- 存放笔记
- 存放任何文件

### 3. 日志查看

**位置：** `openclaw-portable/logs/`

**查看日志：**
- `gateway.log` - 主日志
- `error.log` - 错误日志

---

## 📊 性能优化

### 1. 加速启动

**方法：**
- 把 U盘插到 USB 3.0 接口（蓝色）
- 关闭不用的程序
- 定期清理日志

### 2. 减少体积

**方法：**
- 删除 `logs/` 中的旧日志
- 删除 `workspace/` 中的临时文件
- 压缩：从 679MB 可降到 500MB

---

## 🆘 获取帮助

### 1. 查看文档

- `README.md` - 详细说明
- `QUICK-START.md` - 快速开始
- `INSTALL.md` - 安装指南

### 2. 提交 Issue

**GitHub Issue：**
https://github.com/SonicBotMan/openclaw-portable/issues

### 3. 加入社区

**Discord：**
https://discord.com/invite/clawd

---

## ✨ 小贴士

### 1. 随身携带
- U盘小巧，随身携带
- 在任何电脑上都能用
- 公司、家里、网吧都适用

### 2. 隐私保护
- 关闭后自动清理痕迹
- 不在电脑上留下任何数据
- 适合公共电脑使用

### 3. 离线使用
- 完全不需要网络
- 适合无网络环境
- 适合国内网络环境

---

## 📝 快速参考

### 启动命令

| 平台 | 命令 |
|------|------|
| **Windows** | 双击 `start.bat` |
| **Linux/macOS** | `./start.sh` |

### 关闭命令

| 平台 | 命令 |
|------|------|
| **Windows** | 双击 `stop.bat` |
| **Linux/macOS** | `./stop.sh` |

### 访问地址

```
http://localhost:3000
```

---

## 🎉 总结

**使用流程：**
```
1. 下载 → 2. 解压到 U盘 → 3. 双击启动 → 4. 访问网页
```

**记住三个文件：**
- `start.bat` / `start.sh` - 启动
- `stop.bat` / `stop.sh` - 关闭
- `http://localhost:3000` - 访问

**就这么简单！** 🎉

---

**版本：** v4.0.0
**更新时间：** 2026-03-14
**适用于：** 小白用户

---

**Made with ❤️ by 小茹**
