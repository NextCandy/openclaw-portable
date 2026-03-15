# OpenClaw Portable v5.1 发布说明

## 🎉 新功能：智能配置合并

### 问题
配置面板生成的 `openclaw.json` 会覆盖现有配置，导致以下数据丢失：
- authToken（认证令牌）
- mcp（MCP 服务器配置）
- crons（定时任务）
- authorizedSenders（授权发送者）
- 其他个性化设置

### 解决方案
实现**智能合并**机制，只更新模型配置，保留所有其他设置。

## 📝 改动内容

### 1. config.html（配置面板）
**改动**：只生成 `models.json`（增量配置），而不是完整的 `openclaw.json`

**影响**：
- ✅ 用户下载的文件更小
- ✅ 配置更清晰（只有模型相关字段）
- ✅ 不会误导用户直接覆盖

### 2. install-models.js（合并脚本）
**新增**：智能合并逻辑

**功能**：
- ✅ 读取现有 `openclaw.json`
- ✅ 读取增量 `models.json`
- ✅ 深度合并（只更新 models 字段）
- ✅ 自动备份原配置
- ✅ 显示将要合并的字段
- ✅ 清理临时文件

### 3. apply-config.bat（应用脚本）
**新增**：一键应用配置

**流程**：
1. 检查 Node.js 环境
2. 运行 `install-models.js`
3. 显示成功/失败信息

### 4. README_V5.md（文档）
**更新**：添加智能合并使用说明

## 🚀 使用方法

### 用户视角

1. **打开配置面板**
   ```bash
   双击 config.bat
   ```

2. **填写模型信息**
   - 选择厂商（OpenAI, Anthropic, etc.）
   - 填写 API Key
   - 点击"生成配置文件"

3. **应用配置**
   ```bash
   将下载的 models.json 复制到 OpenClaw Portable 根目录
   双击 apply-config.bat
   ```

4. **重启 Gateway**
   ```bash
   双击 restart.bat
   ```

### 技术细节

**合并逻辑**：
```javascript
// 深度合并，只更新 models 相关字段
const merged = {
  ...existingConfig,     // 保留所有现有配置
  models: {
    providers: {
      ...existingConfig.models.providers,  // 保留旧 providers
      ...newModels.models.providers        // 添加新 providers
    },
    defaults: newModels.models.defaults   // 更新默认模型
  }
};
```

**备份机制**：
- 自动创建时间戳备份
- 位置：`data/.openclaw/backups/openclaw-YYYY-MM-DDTHH-MM-SS.json`
- 最多保留 10 个备份

## ✅ 验证测试

### 测试场景
1. ✅ 现有配置包含多种字段（authToken, mcp, crons, authorizedSenders）
2. ✅ 新配置只包含 models 字段
3. ✅ 合并后保留所有现有字段
4. ✅ 只更新 models 相关字段
5. ✅ 自动备份成功
6. ✅ 临时文件清理成功

### 测试结果
```json
{
  "authToken": "existing-token-123",        // ✅ 保留
  "gateway": {"mode": "local"},              // ✅ 保留
  "models": {
    "providers": {
      "old-provider": {...},                 // ✅ 保留
      "test-provider": {...}                 // ✅ 新增
    },
    "defaults": {"model": "test-model"}      // ✅ 更新
  },
  "mcp": {...},                              // ✅ 保留
  "crons": [...],                            // ✅ 保留
  "authorizedSenders": [...]                 // ✅ 保留
}
```

## 📊 对比

| 特性 | v5.0 | v5.1 |
|------|------|------|
| 配置方式 | 完整覆盖 | ✅ 智能合并 |
| 数据安全 | ❌ 可能丢失 | ✅ 不会丢失 |
| 备份机制 | ❌ 无 | ✅ 自动备份 |
| 可视化提示 | ❌ 无 | ✅ 显示合并字段 |

## 🔄 向后兼容

- ✅ 完全兼容 v5.0 配置文件
- ✅ 现有用户无需修改任何配置
- ✅ 可以继续手动编辑 `openclaw.json`

---

**发布时间**: 2026-03-15 19:05 UTC+8
**版本**: v5.1.0
**改动文件**: 4 个（config.html, install-models.js, apply-config.bat, README_V5.md）
