# U盘盘符变化 - 解决方案

> **Windows 盘符会变？Linux 挂载点会变？完全不用担心！**

---

## 🎯 问题说明

### Windows
- 今天插上是 `E:` 盘
- 明天可能变成 `F:` 盘
- 换个 USB 口可能又变成 `G:` 盘

### Linux/macOS
- 今天挂载到 `/media/user/USB1`
- 明天可能变成 `/media/user/USB2`
- 拔插后路径可能变化

---

## ✅ 解决方案

### 方案 1：智能检测（推荐）

**使用智能启动脚本：**

| 平台 | 脚本 | 特性 |
|------|------|------|
| **Windows** | `start-smart.bat` | 自动检测所有盘符，多 U盘时可选择 |
| **Linux/macOS** | `start-smart.sh` | 自动检测所有挂载点，多 U盘时可选择 |

**Windows 使用：**
```cmd
# 1. 插入 U盘
# 2. 打开 U盘
# 3. 进入 openclaw-portable 目录
# 4. 双击 start-smart.bat
```

**Linux/macOS 使用：**
```bash
# 1. 插入 U盘
# 2. 打开终端
# 3. 运行（不需要知道具体路径）
cd /media/$(whoami)/*/openclaw-portable
./start-smart.sh
```

---

### 方案 2：相对路径（原始方案）

**原理：** 脚本自动获取自己的位置

**Windows：**
```batch
:: 自动获取脚本所在目录
set "USB_ROOT=%~dp0"
```

**Linux/macOS：**
```bash
# 自动获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

**优点：**
- ✅ 不需要知道盘符
- ✅ 自动适应任何盘符
- ✅ 换电脑也能用

**缺点：**
- ⚠️ 需要在 U盘目录中运行脚本
- ⚠️ 多个 U盘时无法选择

---

### 方案 3：环境变量（高级）

**设置环境变量：**

**Windows（添加到 .bashrc）：**
```bash
# 记住 U盘路径
export OPENCLAW_USB=/mnt/e/openclaw-portable

# 启动函数
openclaw-start() {
    cd $OPENCLAW_USB
    ./start.sh
}
```

**Linux/macOS（添加到 .bashrc）：**
```bash
# 自动检测 U盘
detect_usb() {
    for usb in /media/$(whoami)/*; do
        if [ -d "$usb/openclaw-portable" ]; then
            echo "$usb/openclaw-portable"
            return
        fi
    done
}

# 启动函数
openclaw-start() {
    USB_PATH=$(detect_usb)
    if [ -n "$USB_PATH" ]; then
        cd "$USB_PATH"
        ./start.sh
    else
        echo "未检测到 U盘"
    fi
}
```

---

## 📊 方案对比

| 方案 | 优点 | 缺点 | 适用场景 |
|------|------|------|---------|
| **智能检测** | ✅ 自动检测<br>✅ 多 U盘选择<br>✅ 记住路径 | ⚠️ 首次启动稍慢 | **推荐** |
| **相对路径** | ✅ 简单快速<br>✅ 无需配置 | ⚠️ 需在 U盘目录运行<br>⚠️ 多 U盘无法选择 | 快速使用 |
| **环境变量** | ✅ 全局可用<br>✅ 一键启动 | ⚠️ 需配置<br>⚠️ 路径可能过期 | 高级用户 |

---

## 🎯 推荐流程

### Windows 用户

```
1. 插入 U盘
2. 打开 U盘
3. 进入 openclaw-portable 目录
4. 双击 start-smart.bat
5. （如果多个 U盘）选择正确的盘符
6. 自动启动 ✅
```

### Linux/macOS 用户

```
1. 插入 U盘
2. 打开终端
3. 运行（Tab 补全路径）
   cd /media/$(whoami)/*/openclaw-portable
   ./start-smart.sh
4. （如果多个 U盘）选择正确的挂载点
5. 自动启动 ✅
```

---

## 💡 技术细节

### Windows 盘符检测

```batch
:: 循环检测所有盘符（C-Z）
for %%i in (c d e f g h i j k l m n o p q r s t u v w x y z) do (
    if exist "%%i:\openclaw-portable\start.bat" (
        echo 找到 U盘: %%i:
    )
)
```

### Linux 挂载点检测

```bash
# 检测 /media 目录
for user_dir in /media/*; do
    for usb in "$user_dir"/*; do
        if [ -d "$usb/openclaw-portable" ]; then
            echo "找到 U盘: $usb"
        fi
    done
done

# 检测 /Volumes 目录（macOS）
for usb in /Volumes/*; do
    if [ -d "$usb/openclaw-portable" ]; then
        echo "找到 U盘: $usb"
    fi
done
```

---

## 🔒 路径记忆功能

**保存上次使用的路径：**

```bash
# 保存
echo "$USB_PATH" > "$DATA_DIR/.last_usb"

# 读取
if [ -f "$DATA_DIR/.last_usb" ]; then
    LAST_USB=$(cat "$DATA_DIR/.last_usb")
    echo "上次使用: $LAST_USB"
fi
```

**优点：**
- ✅ 下次启动更快
- ✅ 自动选择上次使用的 U盘
- ✅ 数据持久化在 U盘

---

## 🆘 常见问题

### Q1: 检测不到 U盘？

**解决方法：**
1. 检查 U盘是否插入
2. 检查 U盘是否包含 `openclaw-portable` 目录
3. 检查是否有读取权限
4. 手动指定路径：
   ```bash
   ./start.sh /path/to/usb/openclaw-portable
   ```

### Q2: 检测到多个 U盘，不知道选哪个？

**解决方法：**
1. 查看路径提示
2. 选择包含 `openclaw-portable` 的 U盘
3. 拔掉其他 U盘，只保留一个

### Q3: 路径变了，配置丢失了？

**解决方法：**
- 配置保存在 U盘的 `data/` 目录
- 不会因为路径变化而丢失
- 只要 U盘在，配置就在

---

## 📝 总结

**盘符变化完全不是问题！**

| 情况 | 解决方案 | 时间 |
|------|---------|------|
| **单 U盘** | 双击 `start-smart.bat` | 5 秒 |
| **多 U盘** | 双击 → 选择盘符 | 10 秒 |
| **路径变了** | 自动检测，无需操作 | 0 秒 |

**核心：智能脚本自动处理，用户无感知！**

---

**Made with ❤️ by 小茹**
