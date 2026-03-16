# 双版本发布系统 - 实现总结

## 🎯 用户需求

将 openclaw-portable 分拆成两个并行的版本，每次发布都发布这两个版本：
1. 带离线模型的版本
2. 不带离线模型的版本

---

## ✅ 已实现的功能

### 1. 新的 GitHub Actions Workflow

**文件**: `.github/workflows/build-dual-release.yml`

**三个 Job**:

#### Job 1: `build-offline`
- 构建离线版本
- 包含内置的 Qwen2.5-1.5B 模型
- 文件大小: ~1.2 GB
- 目录名: `OpenClaw-Portable-v6.0.0-windows-offline`

#### Job 2: `build-online`
- 构建在线版本
- 不包含内置模型
- 文件大小: ~300 MB
- 目录名: `OpenClaw-Portable-v6.0.0-windows-online`

#### Job 3: `upload-to-release`
- 下载两个构建产物
- 上传到 GitHub Release
- 仅在发布 Release 时触发

---

### 2. 文档更新

#### README.md (英文)
添加了版本对比表和推荐说明：
- 离线版: ~1.2 GB, 内置模型, 完全离线
- 在线版: ~300 MB, 无模型, 使用云端 API

#### README_CN.md (中文)
添加了中文版本对比和推荐说明

#### README_JP.md (日文)
添加了日文版本对比和推荐说明

---

### 3. 触发机制

**Workflow 在以下情况下触发**:
1. **Release 发布时** - 自动构建并上传两个版本
2. **手动触发** - 通过 GitHub Actions 页面

---

## 📦 发布的文件

每次 Release 将包含以下文件:

### 离线版本
- **文件名**: `OpenClaw-Portable-v6.0.0-windows-offline.tar.gz`
- **大小**: ~1.2 GB
- **内容**:
  - Node.js 22.16.0
  - OpenClaw latest
  - llama.cpp b4265
  - Qwen2.5-1.5B-Instruct Q4_K_M 模型 (~900 MB)

### 在线版本
- **文件名**: `OpenClaw-Portable-v6.0.0-windows-online.tar.gz`
- **大小**: ~300 MB
- **内容**:
  - Node.js 22.16.0
  - OpenClaw latest
  - llama.cpp b4265
  - 无内置模型

---

## 🎯 版本对比

| 特性 | 离线版 | 在线版 |
|------|--------|--------|
| **下载大小** | ~1.2 GB | ~300 MB |
| **内置模型** | ✅ Qwen2.5-1.5B | ❌ 无 |
| **离线使用** | ✅ 完全离线 | ❌ 需要网络 |
| **API 成本** | ✅ 零成本 | ⚠️  需要付费 |
| **下载速度** | ⚠️  慢 | ✅ 快 4 倍 |
| **自定义模型** | ✅ 支持 | ✅ 支持 |

---

## 🚀 当前状态

### Release v6.0.1
- ✅ 已创建: https://github.com/SonicBotMan/openclaw-portable/releases/tag/v6.0.1
- ⏳ 构建中: 两个版本正在 GitHub Actions 中构建
- ⏳ 预计时间: 20-30 分钟

### 构建进度
- 📊 Actions 页面: https://github.com/SonicBotMan/openclaw-portable/actions

---

## 💡 使用建议

### 推荐离线版给：
- 无稳定网络连接的用户
- 需要完全离线操作的用户
- 不想支付 API 费用的用户
- 一次性设置，长期使用的用户

### 推荐在线版给：
- 有稳定网络连接的用户
- 已经有 API 密钥的用户
- 想要快速体验的用户
- 有特定模型需求的用户

---

## 🔄 未来优化

1. **自动化测试** - 为两个版本添加自动化测试
2. **版本号同步** - 确保两个版本号同步更新
3. **文档完善** - 添加更详细的使用指南
4. **模型选择** - 未来可能支持更多内置模型选项

---

## 📊 技术细节

### Workflow 并行构建
- 两个 Job 并行运行，节省时间
- 独立的 Artifacts 上传
- Release 时统一上传

### 构建时间
- 离线版: ~20 分钟（包含模型下载）
- 在线版: ~10 分钟（无模型下载）
- 总时间: ~20 分钟（并行执行）

### 存储优化
- Artifacts 保留 90 天
- Release 永久保留
- 模型分片存储在 Release 中

---

## ✅ 完成清单

- [x] 创建新的 GitHub Actions workflow
- [x] 删除旧的 workflow
- [x] 更新英文 README
- [x] 更新中文 README
- [x] 更新日文 README
- [x] 提交到 GitHub
- [x] 创建 v6.0.1 Release
- [x] 触发双版本构建
- [ ] 等待构建完成
- [ ] 验证两个版本都成功上传

---

**创建时间**: 2026-03-16 14:15 UTC
**Release**: v6.0.1
**Workflow**: build-dual-release.yml
