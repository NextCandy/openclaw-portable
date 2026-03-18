# Changelog

All notable changes to OpenClaw Portable will be documented in this file.

## [6.0.1] - 2026-03-18

### Fixed
- **Issue #52** - 禁用本地模型的 `tools` 参数
  - llama.cpp/Ollama 不支持 OpenAI function calling
  - 添加 `capabilities: { tools: false }` 到 bundled-local 配置
  - 避免 "500 Unsupported param: tools" 错误

### Added
- **Issue #43** - 权限和端口检测 + 清理脚本
  - 管理员权限检测（Windows）
  - 端口冲突检测（Gateway + LLM）
  - 敏感文件清理脚本（cleanup.sh / cleanup.bat）
  - 轻度清理：日志、PID 文件
  - 深度清理：配置、令牌、备份

### Changed
- 改善错误提示信息
- 增强用户体验

## [6.0.0] - 2026-03-15

### Added
- **里程碑版本发布** - 基于 v5.0.5 完全重写
- **新手友好文档** - 面向非技术用户重新设计
- **完善的场景支持** - 嶙新的场景描述
- **智能启动流程** - 60秒等待，进度反馈
- **自动 Token 提取** - 自动显示并复制到剪贴板
- **浏览器自动打开** - 带 token 自动访问
- **跨平台支持** - Windows/Linux/macOS 完整支持
- **离线包发布** - 148MB 完整离线包
- **内置本地模型** - Qwen2.5-1.5B CPU-only
- **企业级文档** - INSTALL.md, OFFLINE-GUIDE.md
- **多语言支持** - 中/英/日 文档

### Fixed
- **端口传递问题** - 启动脚本正确传递端口号
- **Token 提取** - 自动从配置文件提取
- **浏览器启动** - 自动带 token 打开

## [5.0.5] - 2026-03-15

### Fixed
- **启动超时** - 增加到 60 秒等待
- **进度反馈** - 每 5 秒显示启动状态
- **错误处理** - 更友好的错误提示

## [5.0.4] - 2026-03-15

### Fixed
- **Windows 脚本语法** - 修复批处理脚本错误
- **端口配置** - 正确传递端口号

## [5.0.3] - 2026-03-15

### Added
- **自动 Token 提取** - 启动后自动显示 token
- **浏览器自动打开** - 带 token 自动访问
- **剪贴板复制** - Token 自动复制

### Fixed
- **用户访问问题** - 解决端口无法访问的 bug

## [5.0.2] - 2026-03-15

### Fixed
- **端口传递** - 启动脚本正确传递端口号
- **环境变量** - 正确设置配置目录

## [5.0.0] - 2026-03-14

### Added
- **首次发布** - 完全离线操作
- **便携式设计** - USB 运行，零痕迹
- **一键启动** - 双击 start.bat 即可

---

For detailed release notes of older versions, see:
- [v5.0.2 Details](https://github.com/SonicBotMan/openclaw-portable/releases/tag/v5.0.2)
- [v5.0.3 Details](https://github.com/SonicBotMan/openclaw-portable/releases/tag/v5.0.3)
- [v5.0.5 Details](https://github.com/SonicBotMan/openclaw-portable/releases/tag/v5.0.5)
