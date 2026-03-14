# OpenClaw Portable 离线安装指南

## 🌐 为什么需要离线包？

中国大陆用户访问以下资源可能很慢：
- Node.js 官方源
- npm 官方源
- GitHub releases

**解决方案：** 离线包 + 国内镜像

---

## 📦 创建离线包（在有网络的机器上）

### 方法1: 自动创建

在有网络的机器上运行：

```bash
chmod +x create-offline.sh
./create-offline.sh
```

会自动下载：
- Node.js 20.x（国内镜像）
- OpenClaw 二进制
- npm 镜像配置

### 方法2: 手动下载

如果自动下载失败，手动下载以下文件：

| 资源 | 下载地址 | 放置位置 |
|------|---------|---------|
| Node.js 20.11.0 (Linux x64) | [国内镜像](https://npmmirror.com/mirrors/node/v20.11.0/node-v20.11.0-linux-x64.tar.xz) | `offline-cache/node.tar.xz` |
| OpenClaw 最新版 | [GitHub](https://github.com/openclaw/openclaw/releases) | `offline-cache/openclaw` |

---

## 📂 离线包目录结构

```
openclaw-portable/
├── offline-cache/              ← 离线缓存目录
│   ├── node.tar.xz          ← Node.js 二进制
│   ├── openclaw             ← OpenClaw 二进制
│   └── .npmrc              ← npm 镜像配置
├── start.bat
├── start.sh
└── ...
```

---

## 🚀 使用离线包

1. 将 `offline-cache` 目录复制到 U盘

2. 在目标机器上运行 `start.bat`

3. 脚本会自动检测并使用离线缓存

---

## ⚡ 加速策略

### 已实现的功能

| 功能 | 说明 |
|------|------|
| **国内镜像检测** | 自动检测是否在中国大陆 |
| **npm 镜像** | 使用 npmmirror.com |
| **Node.js 镜像** | 使用 npmmirror.com/mirrors/node |
| **离线优先** | 优先使用离线缓存 |
| **自动回退** | 离线失败时自动切换在线安装 |

### 镜像源列表

| 资源 | 官方源 | 国内镜像 |
|------|--------|---------|
| npm | registry.npmjs.org | registry.npmmirror.com |
| Node.js | nodejs.org/dist | npmmirror.com/mirrors/node |
| GitHub | github.com | ghproxy.com（可选） |

---

## 🔧 高级配置

### 使用代理

如果用户有代理，可以设置：

```bash
export HTTP_PROXY="http://127.0.0.1:7890"
export HTTPS_PROXY="http://127.0.0.1:7890"
./start.bat
```

### 使用自定义镜像

编辑 `offline-cache/.npmrc`:

```
registry=https://your-mirror.com
disturl=https://your-mirror.com/mirrors/node
```

---

## 📊 性能对比

| 场景 | 传统安装 | 离线包 |
|------|---------|--------|
| **国内首次安装** | 10-30 分钟 | 1-2 分钟 |
| **国内二次安装** | 5-10 分钟 | 10-30 秒 |
| **无网络环境** | ❌ 失败 | ✅ 可用 |

---

## ❓ 常见问题

### Q: 离线包会过期吗？

Node.js 和 OpenClaw 版本会更新，但基本功能不变。建议每 3-6 个月更新一次离线包。

### Q: 离线包很大吗？

- Node.js: ~25MB
- OpenClaw: ~5MB
- 总计: ~30MB

### Q: 可以混用吗？

可以。离线缓存失败时会自动切换在线安装。

---

**版本：** 2.1.0
**更新日期：** 2026-03-14
