# 任务卡片 - Issue #13

## 【任务类型】
安全加固（中等优先级）

## 【目标】
保护敏感信息（API keys、tokens），防止泄露到日志或配置文件中

## 【边界】
**只创建/修改：**
- .gitignore（忽略敏感配置文件）
- README.md（添加安全提示）
- config/openclaw.json.example（配置模板）
- start.sh（设置配置文件权限）
- stop.sh（设置日志文件权限）

**不修改：**
- 不修改核心功能
- 不修改现有配置

## 【非目标】
- 不实现加密功能（太复杂）
- 不实现系统密钥环（平台差异大）

## 【影响范围】**
- 提升用户配置安全性
- 防止敏感信息泄露

---

## 改动点列表

### 1. 创建 .gitignore
**位置：** .gitignore（新建）
**内容：**
```gitignore
# 敏感配置文件
config/openclaw.json
data/.last_usb
*.log
*.env

# 临时文件
.temp/
.tmp/
```

**原因：** 防止敏感配置被提交到 Git

### 2. 创建配置模板
**位置：** config/openclaw.json.example（新建）
**内容：**
```json
{
  "port": 3000,
  "models": {
    "default": "zai/glm-5",
    "YOUR_API_KEY": "在此填入你的 API Key"
  }
}
```

**原因：** 提供配置示例，不包含真实敏感信息

### 3. 添加安全提示到 README.md
**位置：** README.md（修改）
**内容：**
```markdown
## ⚠️ 安全提示

**请勿将以下文件分享或上传到公开仓库：**
- `config/openclaw.json` - 包含 API keys
- `data/.last_usb` - 包含路径信息

**建议：**
1. 定期更换 API keys
2. 不要将 U 盘借给他人
3. 使用环境变量存储敏感信息
```

**原因：** 提醒用户注意安全

### 4. 设置配置文件权限
**位置：** start.sh 第 150 行后
**内容：**
```bash
# 设置配置文件权限（仅所有者可读写）
if [ -f "$TEMP_DIR/openclaw.json" ]; then
    chmod 600 "$TEMP_DIR/openclaw.json"
fi
```

**原因：** 防止其他用户读取配置

### 5. 设置日志文件权限
**位置：** stop.sh
**内容：**
```bash
# 设置日志文件权限（仅所有者可读写，组可读）
find "$DATA_DIR" -name "*.log" -exec chmod 640 {} \; 2>/dev/null
```

**原因：** 限制日志文件访问权限

---

## 验收清单

### A. 需求一致性
- [x] A1. 目标明确：保护敏感信息
- [x] A2. 边界清晰：只创建/修改 5 个文件
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
- [ ] D1. diff 大小合理（<50 行）
- [ ] D2. release note 一致
- [ ] D3. 风险点：低（只加固安全）

---

**创建时间：** 2026-03-14 16:47 UTC+8
**Issue:** #13
**创建人：** 小茹
