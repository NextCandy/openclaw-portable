# OpenClaw Portable v5.0

🚀 **完全离线版本** - 解压即用，无需网络

## 📦 版本说明

v5.0 是全新的离线优先版本，解决了以下核心问题：

| Issue | 问题 | 解决方案 |
|-------|------|----------|
| #40 | README 宣称离线但实际需联网 | ✅ 预置 Node.js + OpenClaw |
| #41 | Base64 代码被杀毒软件拦截 | ✅ 改用 curl.exe，无内嵌脚本 |
| #42 | 无 CI 自动化 | ✅ GitHub Actions 自动构建 |
| #43 | 缺少检测和清理 | ✅ 端口检测 + 退出清理 |

## 📥 下载

### 离线版（推荐）

- **文件**: `OpenClaw-Portable-v5.0.0-windows-offline.zip`
- **大小**: ~200MB
- **特点**: 完全离线，无需网络

### 在线版（可选）

- **文件**: `OpenClaw-Portable-v5.0.0-windows-online.zip`
- **大小**: <1MB
- **特点**: 首次运行自动下载依赖

## 🚀 使用方法

### 离线版

1. 解压到 U 盘
2. 双击 `start.bat`
3. 访问 http://localhost:18789

**✅ 无需任何网络连接！**

### 在线版

1. 解压到 U 盘
2. 双击 `start-online.bat`（首次需联网）
3. 访问 http://localhost:18789

## 📁 目录结构

```
OpenClaw-Portable-v5.0/
├── node/                  # Node.js 22.16.0 (预置)
├── openclaw-pkg/          # OpenClaw (预置)
├── data/                  # 用户数据
├── workspace/             # 工作空间
├── temp/                  # 临时文件
├── config/                # 配置文件
├── start.bat              # 启动脚本（离线）
├── start-online.bat       # 启动脚本（在线）
├── stop.bat               # 停止脚本（含清理）
└── check.bat              # 环境检测
```

## ✨ 新特性

### v5.0

- ✅ **完全离线** - 预置所有依赖，无需网络
- ✅ **安全可靠** - 无内嵌 Base64，不触发杀毒软件
- ✅ **智能检测** - 端口冲突自动切换备用端口
- ✅ **零痕迹** - 退出时自动清理临时文件
- ✅ **CI 自动化** - GitHub Actions 自动构建发布

## 🔧 脚本说明

| 脚本 | 用途 |
|------|------|
| start.bat | 离线启动（推荐） |
| start-online.bat | 在线启动（首次需网络） |
| stop.bat | 停止服务 + 清理临时文件 |
| check.bat | 环境检测工具 |

## 🛡️ 安全说明

- ✅ 无内嵌 Base64 代码
- ✅ 无注册表写入
- ✅ 无系统目录安装
- ✅ 所有数据存储在 U 盘

## 📊 对比

| 特性 | v4.x | v5.0 |
|------|------|------|
| 离线运行 | ❌ 首次需网络 | ✅ 完全离线 |
| 杀毒软件 | ⚠️ 可能拦截 | ✅ 无问题 |
| 端口检测 | ❌ 无 | ✅ 自动检测 |
| 退出清理 | ❌ 无 | ✅ 自动清理 |
| CI 自动化 | ❌ 无 | ✅ GitHub Actions |

---

**推荐下载离线版！** 🎉

## 🎨 可视化配置面板

### 快速配置模型

1. **打开配置面板**
   - 双击 `open-config.bat`
   - 或用浏览器打开 `config-ui/index.html`

2. **选择模型厂商**
   - OpenAI (GPT-4, GPT-3.5)
   - Anthropic (Claude)
   - Google (Gemini)
   - 智谱 AI (GLM)
   - DeepSeek
   - Moonshot (Kimi)
   - 自定义

3. **填写配置**
   - 模型名称 (如: gpt-4o, claude-3-5-sonnet)
   - API 类型 (通常自动选择)
   - API 地址 (通常自动填充)
   - API Key

4. **保存并重启**
   - 点击"保存并重启 Gateway"
   - 将下载的 `openclaw.json` 复制到 `data\.openclaw\`
   - 或直接运行 `restart.bat`

### 配置文件位置

```
data/
└── .openclaw/
    └── openclaw.json
```

### 手动配置示例

```json
{
  "gateway": {
    "mode": "local"
  },
  "agents": {
    "defaults": {
      "modelConfig": {
        "api": "openai-chat",
        "baseUrl": "https://api.openai.com/v1",
        "model": "gpt-4o"
      }
    },
    "providers": {
      "openai": {
        "api": "openai-chat",
        "baseUrl": "https://api.openai.com/v1",
        "models": [
          {
            "name": "gpt-4o",
            "apiKey": "sk-your-api-key-here"
          }
        ]
      }
    }
  }
}
```

---

*更新时间: 2026-03-15 02:26 UTC+8*
