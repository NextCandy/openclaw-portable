# Changelog

All notable changes to OpenClaw Portable will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - 2026-03-14

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

### Fixed
- 修复 Node.js 版本不兼容问题（升级到 v22.14.0）
- 修复国内用户下载慢的问题（预置所有依赖）
- 修复换电脑需要重新安装的问题

### Security
- 关闭时自动清理临时文件
- 不在本地留下任何痕迹
- 所有数据保存在 U盘

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
