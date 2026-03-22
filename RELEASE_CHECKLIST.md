# 📋 Release Checklist

每次发布前必须逐项确认的检查清单，确保发布质量和一致性。

---

## ✅ 发布前检查清单

### 1. 代码准备
- [ ] 所有代码已合并到 `main` 分支
- [ ] 所有测试通过（如有）
- [ ] 代码审查完成

### 2. 版本号一致性检查

**必须检查以下文件的版本号**：

- [ ] `package.json`（如存在）
- [ ] `README.md` - 版本号和下载链接
- [ ] `README_CN.md` - 版本号和下载链接
- [ ] `README_JP.md` - 版本号和下载链接
- [ ] `CHANGELOG.md` - 新版本记录
- [ ] `start.bat` - 标题栏版本号
- [ ] `start.sh` - 欢迎信息版本号
- [ ] `build-offline-package.sh` - 输出目录名

**版本号格式**：`vX.Y.Z`（例如 `v6.0.1`）

### 3. CHANGELOG 更新
- [ ] 添加新版本记录
- [ ] 记录所有变更（Added / Changed / Fixed / Removed）
- [ ] 关联相关 Issue 编号

### 4. Git 标签和提交
- [ ] 创建 Git tag：`git tag -a vX.Y.Z -m "Release vX.Y.Z"`
- [ ] 推送 tag：`git push origin vX.Y.Z`

### 5. GitHub Release 创建
- [ ] 在 GitHub 上创建 Release
- [ ] Release tag 与 Git tag 一致
- [ ] Release name 格式：`vX.Y.Z - <Description>`
- [ ] Release body 包含 CHANGELOG 内容
- [ ] **不要点击 "Publish"**，直到 Assets 准备好

### 6. 构建 Assets
- [ ] 运行构建脚本生成离线包和在线包
- [ ] 验证生成的文件名包含正确版本号
  - `OpenClaw-Portable-vX.Y.Z-windows-offline.tar.gz`
  - `OpenClaw-Portable-vX.Y.Z-windows-online.tar.gz`
- [ ] 验证文件大小合理（离线版 ~1.2GB，在线版 ~300MB）

### 7. 上传 Assets
- [ ] 上传离线包到 Release
- [ ] 上传在线包到 Release
- [ ] 验证下载链接正确
- [ ] **点击 "Publish" 发布**

### 8. 发布后验证
- [ ] 访问 GitHub Release 页面验证
- [ ] 下载并测试离线包
- [ ] 下载并测试在线包
- [ ] 验证版本号显示正确

### 9. Issue 管理
- [ ] 关闭已实现的相关 Issues
- [ ] 添加完成评论说明版本号
- [ ] 更新 Issue 标签（如需要）

---

## ⚠️ 常见问题

### Q1: Assets 文件名版本号错误怎么办？
**A**: 不要发布！重新构建并重命名文件，确保版本号一致。

### Q2: 忘记创建 Git tag 怎么办？
**A**: 先创建 tag 再推送，然后创建 GitHub Release。

### Q3: Release 已经发布但有问题怎么办？
**A**: 
1. 如果只是 Release notes 问题，可以编辑
2. 如果是 Assets 问题，需要删除 Release 重新发布
3. 如果是代码问题，需要发布新版本修复

### Q4: 多个版本同时发布怎么办？
**A**: 严格按版本号顺序发布，确保 CHANGELOG 时间线正确。

---

## 🔧 自动化建议

考虑使用 GitHub Actions 自动化部分流程：

1. **自动构建**：Release 创建时自动构建 Assets
2. **自动上传**：构建完成后自动上传到 Release
3. **自动检查**：验证版本号一致性
4. **自动关闭 Issues**：根据 commit message 自动关闭 Issues

---

## 📝 发布记录模板

```markdown
## 📦 vX.Y.Z - <Description>

### Added
- 新功能描述

### Changed
- 变更描述

### Fixed
- 修复描述 (#IssueNumber)

### Removed
- 移除描述

---

**📥 下载文件**：
- `OpenClaw-Portable-vX.Y.Z-windows-offline.tar.gz` (约 1.2 GB) - 离线版
- `OpenClaw-Portable-vX.Y.Z-windows-online.tar.gz` (约 300 MB) - 在线版
```

---

## 🎯 快速发布命令

```bash
# 1. 更新版本号（手动编辑文件）
vim package.json README.md README_CN.md CHANGELOG.md start.bat start.sh

# 2. 提交变更
git add .
git commit -m "chore: bump version to vX.Y.Z"
git push

# 3. 创建 tag
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z

# 4. 构建 Assets
./build-offline-package.sh

# 5. 在 GitHub 上创建 Release 并上传 Assets

# 6. 验证发布
open https://github.com/SonicBotMan/openclaw-portable/releases/tag/vX.Y.Z
```

---

**⚠️ 记住**：发布是不可逆的，慢一点没关系，但要确保正确性！
