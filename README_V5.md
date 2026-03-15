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

### 快速配置模型（智能合并）

1. **打开配置面板**
   - 双击 `config.bat`
   - 或用浏览器打开 `config.html`

2. **选择模型厂商**
   - OpenAI (GPT-4o)
   - Anthropic (Claude)
   - Google (Gemini)
   - 智谱 AI (GLM)
   - DeepSeek
   - 自定义

3. **填写配置**
   - 模型名称 (如: gpt-4o, claude-3-5-sonnet)
   - API 地址 (通常自动填充)
   - API Key

4. **生成并应用配置**
   - 点击 "💾 生成配置文件"
   - 将下载的 `models.json` 复制到 OpenClaw Portable 根目录
   - 双击 `apply-config.bat` 应用配置
   - 运行 `restart.bat` 重启 Gateway

### ⚡ 智能合并特性

- ✅ **只更新模型配置** - 不会覆盖其他设置
- ✅ **自动备份** - 应用前自动备份原配置
- ✅ **安全可靠** - 显示将要合并的字段

### 配置文件位置

```
OpenClaw-Portable/
├── config.html           # 配置面板
├── apply-config.bat      # 应用配置脚本
├── install-models.js     # 合并逻辑
├── models.json           # 临时配置文件（应用后自动删除）
└── data/
    └── .openclaw/
        ├── openclaw.json     # 主配置文件
        └── openclaw.json.bak # 自动备份
```

### 手动配置示例

如果需要手动编辑，可以参考以下结构：

```json
{
  "models": {
    "providers": {
      "openai": {
        "api": "openai-chat",
        "baseUrl": "https://api.openai.com/v1",
        "models": [{"name": "gpt-4o", "apiKey": "sk-..."}]
      }
    },
    "defaults": {
      "model": "gpt-4o"
    }
  }
}
```

---

*更新时间: 2026-03-15 02:26 UTC+8*
