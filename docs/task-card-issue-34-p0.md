# 任务卡片 - Issue #34（P0 Bug）

## 【任务类型】
Bug 修复（严重）

## 【目标】
修复 2 个 P0 严重 Bug，确保项目在 Windows 和 Linux/macOS 上都能正常工作

## 【边界】
**只修改：**
- start.bat（添加 enabledelayedexpansion）
- start.sh（修复 set -e + grep -q 问题）
- stop.sh（修复 set -e + grep -q 问题）

**不修改：**
- 不修改功能逻辑
- 不修改其他文件
- 不添加新功能

## 【非目标】
- 不修复 P1 Bug（Bug 2, Bug 4）
- 不修复设计问题（Design 1, 2, 3）
- 不重构代码

## 【影响范围】
- Windows 用户：start.bat 能正常检测 U盘
- Linux/macOS 用户：start.sh/stop.sh 能正常启动/停止服务

---

## 改动点列表

### 1. Bug 1: start.bat 添加 enabledelayedexpansion
**位置：** start.bat 第 3 行
**修改前：** 无
**修改后：** `setlocal enabledelayedexpansion`
**原因：** 启用延迟变量扩展，使 `!VAR!` 语法生效

### 2. Bug 3: start.sh 修复 set -e + grep -q 问题
**位置：** start.sh 第 206-211 行
**修改前：**
```bash
if openclaw gateway status &>/dev/null | grep -q "running"; then
    echo -e "${YELLOW}⚠️  OpenClaw 已在运行，跳过启动${NC}"
else
    openclaw gateway start
    sleep 2
fi
```

**修改后：**
```bash
STATUS=$(openclaw gateway status 2>/dev/null || true)
if echo "$STATUS" | grep -q "running"; then
    echo -e "${YELLOW}⚠️  OpenClaw 已在运行，跳过启动${NC}"
else
    openclaw gateway start
    sleep 2
fi
```

**原因：** 防止 `set -e` + `grep -q` 导致脚本提前退出

### 3. Bug 3: stop.sh 修复 set -e + grep -q 问题
**位置：** stop.sh（类似位置）
**修改前：** 类似问题
**修改后：** 使用 `|| true` 捕获状态
**原因：** 同上

---

## 验收清单

### A. 需求一致性
- [x] A1. 目标明确：修复 P0 Bug
- [x] A2. 边界清晰：只修改 3 个文件
- [x] A3. 改动与 issue 一致

### B. 技术正确性
- [x] B1. 基于正确版本（当前 main 分支）
- [x] B2. 没有重写文件
- [x] B3. 无数据结构变化
- [x] B4. 不破坏旧逻辑

### C. 测试验证
- [ ] C1. 语法检查通过
- [ ] C2. 导入验证通过
- [ ] C3. 行为验证通过
- [ ] C4. 回归验证通过

### D. 发布质量
- [ ] D1. diff 大小合理（<30 行）
- [ ] D2. release note 一致
- [ ] D3. 文档已同步
- [ ] D4. 风险点：低（只修复严重 Bug）

---

**创建时间：** 2026-03-14 15:20 UTC+8
**Issue:** #34
**创建人：** 小茹
