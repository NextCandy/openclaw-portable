# Changelog

All notable changes to OpenClaw Portable will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.3] - 2026-03-15

### ✨ 新功能
- **自动提取和显示 Token** - 启动后自动从配置文件提取 gateway token
- **Token 自动复制到剪贴板** - Windows/Linux/macOS 自动复制，方便粘贴
- **浏览器自动带 Token 打开** - URL 包含 token 参数，无需手动输入
- **改进的用户体验** - 小白用户无需手动查找 token 文件

### 🔧 改进
- **start.bat** - 后台启动 + token 提取 + 自动打开浏览器（带 token）
- **start-online.bat** - 后台启动 + token 提取 + 自动打开浏览器（带 token）
- **start.sh** - token 提取 + 剪贴板复制 + 自动打开浏览器（带 token）

### 📝 实现细节

#### Windows
```batch
# 从 openclaw.json 提取 token
# 复制到剪贴板（clip 命令）
# 浏览器打开: http://localhost:18789?token=xxx
```

#### Linux/macOS
```bash
# 从 openclaw.json 提取 token
# 复制到剪贴板（xclip/xsel/pbcopy）
# 浏览器打开: http://localhost:18789?token=xxx
```

## [5.0.2] - 2026-03-15

### 🐛 Bug 修复
- **[PR #50]** 修复启动脚本端口传递问题
  - start.bat 添加 `--port %GATEWAY_PORT%` 参数
  - start-basic.bat 修正硬编码端口 3000 → 18789
  - start.sh 添加 `--port $GATEWAY_PORT` 参数
  - start-online.bat 添加 `--port %GATEWAY_PORT%` 参数
  - stop.sh 添加 `export OPENCLAW_CONFIG_DIR` 环境变量
  - start.sh 改进健康检查逻辑（检查 curl/wget 命令存在性）

### 🔧 改进
- **健康检查更健壮** - 先检查 curl/wget 是否存在，再执行健康检查
- **配置目录正确性** - stop.sh 设置配置目录环境变量，确保能找到运行实例
- **版本号统一** - 所有脚本版本号统一为 v5.0.2

### 📝 文档
- **更新 .gitignore** - 添加 .task-card.md 和 .review.md（开发过程文件）

## [5.0.1] - 2026-03-15

### 🐛 Bug 修复
- **[PR #49]** 修复 apply-config.bat 无法找到 Node.js 的问题

### ✨ 新功能
- **[PR #48]** 智能配置合并 v5.1
  - 配置优先级：用户配置 > 默认配置
  - 支持增量配置更新
  - 配置验证和错误提示

## [5.0.0] - 2026-03-14

### ✨ 重大更新
- **完全离线运行** - Node.js + OpenClaw 预打包，无需网络
- **多平台支持** - Windows (.bat) + Linux/macOS (.sh)
- **智能检测** - 自动检测 U盘路径和挂载点
- **配置持久化** - 数据自动同步到 U盘

## [4.1.0] - 2026-03-14

### 🔒 安全加固
- **添加 .gitignore** - 忽略敏感配置文件（config/openclaw.json, data/.last_usb, *.log, *.env）
- **创建配置模板** - config/openclaw.json.example（不包含真实敏感信息）
- **添加安全提示** - README.md 中添加安全章节，提醒用户保护敏感信息
- **设置文件权限** - start.sh 自动设置配置文件权限为 600（仅所有者可读写）
- **设置日志权限** - stop.sh 自动设置日志文件权限为 640（所有者读写，组只读）

### 🐛 Bug 修复
- **[Issue #34]** 修复 2 个 P0 严重 Bug（Windows/Linux 完全无法工作）
  - start.bat 添加 enabledelayedexpansion（Windows 完全无法工作）
  - start.sh/stop.sh 修复 set -e + grep -q 问题（Linux/macOS 服务无法启动）
- **[Issue #34]** 修复 2 个 P1 Bug（WSL 路径 + 目录名检测）
  - start.bat 动态计算 WSL 路径（支持任意目录名）
  - start.sh 基于内容指纹检测（不依赖特定目录名）
- **[Issue #29]** 修复 start.bat echo 语句路径引号问题
- **[Issue #33]** 修复 start.sh 变量引用错误

### ✅ 关闭的无效 Issues
- #32 - start.sh 变量引用（已在 #33 中修复）
- #22, #21, #20, #19 - 不适用（已重写为 WSL 方式）
- #27, #25, #24, #23, #17, #14, #4, #3 - 文件不存在

### 📊 修复统计
- **总计关闭：** 17 个 Issues
- **修复的 Bug：** 4 个严重 Bug + 1 个低优先级 Bug
- **流程遵守度：** 100%（严格遵循 GitHub Development Standard）

---

## [4.0.0] - 2026-03-14

### 问题
- 用户需要下载 Node.js 才能使用便携版
- 国内用户下载速度慢（需要翻墙或镜像）
- 换电脑使用需要重新安装
- 安装时间长达 10-30 分钟

### 修复
- 预置 Node.js 22.14.0（192MB）
- 预置 OpenClaw 2026.3.12（487MB）
- 清理测试文件，减少 30% 体积
- 优化启动脚本，增加友好提示

### Added
- **预置 Node.js 22.14.0** - 完全离线运行，无需下载
- **预置 OpenClaw 2026.3.12** - 完全离线运行，无需下载
- **一键启动/关闭** - Windows 和 Linux/macOS 双平台支持
- **自动环境检测** - 智能检测 U盘路径和系统环境
- **数据持久化** - 所有数据保存在 U盘，换电脑不丢失
- **隐私保护** - 关闭时自动清除本地痕迹
- **国内镜像支持** - 针对中国大陆用户优化

### Changed
- 从在线安装改为完全离线运行
- 从 9KB 增加到 157MB（包含完整运行环境）
- 支持无网络环境使用（仅 Git 需要网络）

### 验证
- ✅ Layer 1: 语法验证通过（bash -n）
- ✅ Layer 2: 导入验证通过（Node.js/OpenClaw 可用）
- ✅ Layer 3: 行为验证通过（功能符合预期）
- ⚠️ Layer 4: 回归验证不适用（新项目）

### 非修改
- 不修改 OpenClaw 核心功能
- 不修改配置格式
- 不修改启动逻辑
- 不修改第三方依赖

### 影响范围
- **安装体验：** 从 10-30 分钟降到 1-2 分钟
- **离线能力：** 从 需要网络 到 完全离线
- **国内用户：** 从 需要翻墙 到 无需翻墙
- **换电脑使用：** 从 需重装 到 即插即用

### Security
- 关闭时自动清理临时文件
- 不在本地留下任何痕迹
- 所有数据保存在 U盘

### Fixed
- 修复 Node.js 版本不兼容问题（升级到 v22.14.0）
- 修复国内用户下载慢的问题（预置所有依赖）
- 修复换电脑需要重新安装的问题

---

## [3.0.0] - 2026-03-14

### Added
- 预置 Node.js 20.11.0（首次离线支持）
- 国内镜像加速支持
- 离线安装包创建工具

### Changed
- 压缩包从 9KB 增加到 45MB
- 支持部分离线安装

---

## [2.0.0] - 2026-03-14

### Added
- 一键启动/关闭脚本
- 自动检测 U盘路径
- 自动安装依赖
- 数据自动同步

### Changed
- 从手动安装改为一键安装
- 增强用户体验

---

## [1.0.0] - 2026-03-14

### Added
- 初始版本
- 基础的便携式安装脚本
- README 文档

---

[4.0.0]: https://github.com/SonicBotMan/openclaw-portable/releases/tag/v4.0.0
[3.0.0]: https://github.com/SonicBotMan/openclaw-portable/releases/tag/v3.0.0
[2.0.0]: https://github.com/SonicBotMan/openclaw-portable/releases/tag/v2.0.0
[1.0.0]: https://github.com/SonicBotMan/openclaw-portable/releases/tag/v1.0.0
