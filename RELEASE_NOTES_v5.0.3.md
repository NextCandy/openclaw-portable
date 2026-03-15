# Release Notes v5.0.3

**发布日期：** 2026-03-15
**类型：** 用户体验改进版本

---

## ✨ 重大改进

### 自动提取和显示 Token

**问题：**
- 用户需要手动在 `data\.openclaw\openclaw.json` 中查找 token
- 对小白用户来说太复杂

**解决方案：**
- ✅ 启动后自动从配置文件提取 gateway token
- ✅ Token 显示在控制台窗口
- ✅ 自动复制到剪贴板
- ✅ 浏览器自动带 token 打开（完全自动化）

---

## 🎯 用户体验对比

### v5.0.2（改进前）

```
1. 运行 start.bat
2. 打开浏览器访问 http://localhost:18789
3. 提示输入 token
4. 打开文件管理器
5. 导航到 data\.openclaw\openclaw.json
6. 用记事本打开
7. 复制 token
8. 粘贴到浏览器
```

**步骤：8 步**
**难度：⭐⭐⭐⭐**

### v5.0.3（改进后）

```
1. 运行 start.bat
2. 等待浏览器自动打开（已带 token）
```

**步骤：1 步**
**难度：⭐**

---

## 📦 改进内容

### Windows (start.bat, start-online.bat)

| 功能 | 实现 |
|------|------|
| **后台启动** | `start /b` 后台运行 OpenClaw |
| **等待启动** | 检测端口 18789 是否监听 |
| **提取 Token** | 从 `data\.openclaw\openclaw.json` 提取 |
| **显示 Token** | 在控制台显示 |
| **复制到剪贴板** | `clip` 命令自动复制 |
| **浏览器打开** | `http://localhost:18789?token=xxx` |

### Linux/macOS (start.sh)

| 功能 | 实现 |
|------|------|
| **后台启动** | `openclaw gateway start` 后台运行 |
| **等待启动** | curl/wget 健康检查 |
| **提取 Token** | grep + sed 从 JSON 提取 |
| **显示 Token** | 在终端显示 |
| **复制到剪贴板** | xclip/xsel/pbcopy 自动复制 |
| **浏览器打开** | xdg-open/open `http://localhost:18789?token=xxx` |

---

## 🎬 启动后效果

### Windows

```
==========================================
  Gateway is ready!
==========================================

  Access URL: http://localhost:18789
  Token:      abc123def456...

  [OK] Token copied to clipboard

  Direct link (with token):
  http://localhost:18789?token=abc123def456...

  [浏览器自动打开]
==========================================
```

### Linux/macOS

```
╔════════════════════════════════════════╗
║          ✅ 启动成功！                 ║
╚════════════════════════════════════════╝

  访问地址: http://localhost:18789
  Token:      abc123def456...

  ✅ Token 已复制到剪贴板

  直接访问链接（含 Token）:
  http://localhost:18789?token=abc123def456...

  [浏览器自动打开]
```

---

## 🚀 升级指南

### 从 v5.0.2 升级

1. **下载新版本**
   - Windows: 下载离线包
   - Linux/macOS: `git pull`

2. **迁移配置**（可选）
   ```bash
   cp -r 旧版本/data 新版本/data
   ```

3. **启动新版本**
   ```bash
   # Windows
   start.bat

   # Linux/macOS
   ./start.sh
   ```

4. **享受自动化**
   - 无需手动查找 token
   - 浏览器自动打开（已带 token）

---

## 📊 技术实现

### Token 提取（Windows）

```batch
rem 从 JSON 提取 token
for /f "tokens=2 delims=:" %%a in ('findstr /C:"\"token\"" "%CONFIG_FILE%"') do (
    set "TOKEN_LINE=%%a"
    set "TOKEN_LINE=!TOKEN_LINE:"=!"
    set "TOKEN_LINE=!TOKEN_LINE:,=!"
    set "GATEWAY_TOKEN=!TOKEN_LINE!"
)

rem 复制到剪贴板
echo !GATEWAY_TOKEN! | clip

rem 打开浏览器（带 token）
start http://localhost:18789?token=!GATEWAY_TOKEN!
```

### Token 提取（Linux/macOS）

```bash
# 从 JSON 提取 token
GATEWAY_TOKEN=$(grep -o '"token"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | \
    sed 's/.*"token"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# 复制到剪贴板
echo "$GATEWAY_TOKEN" | xclip -selection clipboard

# 打开浏览器（带 token）
xdg-open "http://localhost:18789?token=$GATEWAY_TOKEN"
```

---

## 🔗 链接

- **PR**: (待创建)
- **Commit**: (待提交)

---

**感谢使用 OpenClaw Portable！让 AI 更简单！** 🎉
