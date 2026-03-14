# 任务卡片 - Issue #34（P1 Bug）

## 【任务类型】
Bug 修复（重要）

## 【目标】
修复 2 个 P1 重要 Bug，提升脚本的健壮性和灵活性

## 【边界】
**只修改：**
- start.bat（修复 WSL 路径硬编码）
- start.sh（修复目录名检测脆弱）

**不修改：**
- 不修改功能逻辑
- 不修改其他文件
- 不添加新功能

## 【非目标】
- 不修复设计问题（Design 1, 2, 3）
- 不重构代码
- 不优化性能

## 【影响范围】**
- WSL 路径转换：支持任意目录名
- Linux/macOS 检测：不依赖特定目录名

---

## 改动点列表

### 1. Bug 2: start.bat 修复 WSL 路径硬编码
**位置：** start.bat 第 96-99 行
**修改前：**
```batch
set "DRIVE_LETTER=%USB_ROOT:~0,1%"
set "WSL_USB=/mnt/%DRIVE_LETTER%/openclaw-portable"
```

**修改后：**
```batch
set "SCRIPT_FULL=%~dp0"
set "SCRIPT_FULL=%SCRIPT_FULL:~0,-1%"
set "DRIVE_LETTER=%SCRIPT_FULL:~0,1%"
set "SCRIPT_PATH=%SCRIPT_FULL:~2%"
set "SCRIPT_PATH=%SCRIPT_PATH:\=/%"
set "WSL_USB=/mnt/%DRIVE_LETTER%%SCRIPT_PATH%"
```

**原因：** 支持任意目录名，自动转换反斜杠

### 2. Bug 4: start.sh 修复目录名检测脆弱
**位置：** start.sh 第 48-65 行
**修改前：**
```bash
if [[ "$SCRIPT_DIR" == *"/openclaw-portable" ]] && [ -f "$SCRIPT_DIR/start.sh" ]; then
```

**修改后：**
```bash
if [ -f "$SCRIPT_DIR/start.sh" ] && [ -d "$SCRIPT_DIR/node" ]; then
```

**原因：** 基于内容指纹检测，不依赖特定目录名

---

## 验收清单

### A. 需求一致性
- [x] A1. 目标明确：修复 P1 Bug
- [x] A2. 边界清晰：只修改 2 个文件
- [x] A3. 改动与 issue 一致

### B. 技术正确性
- [x] B1. 基于正确版本（commit e290edd）
- [x] B2. 没有重写文件
- [x] B3. 无数据结构变化
- [x] B4. 不破坏旧逻辑

### C. 测试验证
- [ ] C1. 语法检查通过
- [ ] C2. 导入验证通过
- [ ] C3. 行为验证通过
- [ ] C4. 回归验证通过

### D. 发布质量
- [ ] D1. diff 大小合理（<20 行）
- [ ] D2. release note 一致
- [ ] D3. 文档已同步
- [ ] D4. 风险点：低（只提升健壮性）

---

**创建时间：** 2026-03-14 15:43 UTC+8
**Issue:** #34
**创建人：** 小茹
