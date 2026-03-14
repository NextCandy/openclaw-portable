# 改动点列表 - Issue #15

## 基线版本
Commit: 591b95ad3b31f3511e824d37c5e43a22ede72157
分支: main
时间: 2026-03-14 13:01:10 +0800

---

## 改动点 1：重命名基础版 Windows 启动脚本

**位置：** `start.bat` → `start-basic.bat`
**类型：** 文件重命名
**原因：** 保留基础版作为备用

**命令：**
```bash
git mv start.bat start-basic.bat
```

**影响：**
- 保留原文件内容
- 文件名变化
- Git 历史保留

---

## 改动点 2：重命名基础版 Linux/macOS 启动脚本

**位置：** `start.sh` → `start-basic.sh`
**类型：** 文件重命名
**原因：** 保留基础版作为备用

**命令：**
```bash
git mv start.sh start-basic.sh
```

**影响：**
- 保留原文件内容
- 文件名变化
- Git 历史保留

---

## 改动点 3：重命名智能版 Windows 启动脚本

**位置：** `start-smart.bat` → `start.bat`
**类型：** 文件重命名
**原因：** 智能版设为默认

**命令：**
```bash
git mv start-smart.bat start.bat
```

**影响：**
- 智能版成为默认启动脚本
- 文件名变化
- Git 历史保留

---

## 改动点 4：重命名智能版 Linux/macOS 启动脚本

**位置：** `start-smart.sh` → `start.sh`
**类型：** 文件重命名
**原因：** 智能版设为默认

**命令：**
```bash
git mv start-smart.sh start.sh
```

**影响：**
- 智能版成为默认启动脚本
- 文件名变化
- Git 历史保留

---

## 改动点 5：更新 README.md

**位置：** `README.md`
**类型：** 文档更新
**原因：** 说明新的启动方式

**修改内容：**
```markdown
## 🚀 使用方法

### Windows 用户
1. 双击 `start.bat`（智能检测 U盘）
2. 如需基础版：双击 `start-basic.bat`

### Linux/macOS 用户
1. 运行 `./start.sh`（智能检测 U盘）
2. 如需基础版：运行 `./start-basic.sh`
```

---

## 改动统计

| 类型 | 数量 | 说明 |
|------|------|------|
| 文件重命名 | 4 | start.bat, start.sh, start-smart.bat, start-smart.sh |
| 文档修改 | 1 | README.md |
| **总计** | **5** | **4 重命名 + 1 文档** |

---

## 风险评估

| 风险 | 等级 | 说明 | 缓解措施 |
|------|------|------|---------|
| 用户混淆 | 低 | 脚本名称变化 | README.md 说明 |
| 脚本损坏 | 无 | 只重命名，不修改内容 | Git 保留历史 |
| 启动失败 | 无 | 智能版已测试 | 基础版备用 |

**总体风险：** ✅ **无风险**（纯重命名 + 文档）

---

**创建时间：** 2026-03-14 13:06 UTC+8
**Issue:** #15
