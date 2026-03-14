# 🚀 OpenClaw Portable

### 世界初の完全オフラインAIアシスタント - ネットワーク不要

[中文](README_CN.md) | [English](README.md) | **日本語**

---

## 🎯 解決する課題

**従来のAIアシスタントの問題点：**
- ❌ インストールに10-30分かかる
- ❌ 安定したインターネット接続が必要
- ❌ 制限地域ではVPNが必要
- ❌ 新しいデバイスごとに再インストール
- ❌ データが各デバイスに分散

**結果？** 時間の無駄、イライラ、プライバシーの懸念。

---

## 💝 私たちの解決策：OpenClaw Portable

**世界初のAIアシスタント：**
- ✅ **完全オフライン動作** - 展開後はネットワーク不要
- ✅ **60秒でインストール** - 展開して実行するだけ
- ✅ **USBから実行** - AIもデータも、どこでも
- ✅ **痕跡を残さない** - 共有/公共PCに最適
- ✅ **自動同期** - データはマシンではなく、あなたと共に

**1つのUSB。1回のクリック。ストレスフリー。**

---

## 🌟 核となる価値

| 特徴 | 従来のインストール | ポータブル版 |
|------|------------------|-------------|
| **インストール時間** | 10-30分 | **60秒** |
| **ネットワーク必要** | ✅ 必須 | ❌ **不要** |
| **ダウンロードサイズ** | ~500MB | **0** |
| **デバイス間移動** | ❌ 再インストール | ✅ **USB差すだけ** |
| **データ同期** | ❌ 手動 | ✅ **自動** |
| **プライバシー** | ❌ 痕跡あり | ✅ **痕跡なし** |

---

## 🎯 使用シーン

### ✅ 完璧なフィット

| シーン | なぜ完璧か |
|--------|-----------|
| **会社PC** | 痕跡なし、データはUSB |
| **ネットカフェ/公共PC** | 挿すだけ、閉じればクリア |
| **オフライン環境** | Gitのみネットワーク必要（通常システムにインストール済み） |
| **複数デバイス** | 自動同期、シームレス切り替え |
| **制限されたネットワーク** | VPN不要、ミラー不要 |

---

## 🚀 クイックスタート

### Windows ユーザー

**1分で起動：**
```batch
# 1. USBに展開（1分）
OpenClaw-Portable-v4.1.0.zipを展開

# 2. 起動（初回30秒）
start.batをダブルクリック

# 3. アクセス
ブラウザで http://localhost:3000 を開く

# 4. 終了
stop.batをダブルクリック
```

**✅ 完了！データはUSB、ローカルに痕跡なし**

### Linux/macOS ユーザー

```bash
# 1. 展開
tar -xzf OpenClaw-Portable-v4.1.0.tar.gz

# 2. 起動
cd /media/$(whoami)/*/OpenClaw-Portable
./start.sh

# 3. アクセス
ブラウザで http://localhost:3000 を開く

# 4. 終了
./stop.sh
```

---

## 📦 含まれるもの

```
OpenClaw-Portable/
├── node/              ← Node.js 22.14.0 (192MB)
├── npm-global/        ← OpenClaw 2026.3.12 (487MB)
├── start.bat          ← Windows スマート起動
├── stop.bat           ← Windows スマート終了
├── start.sh           ← Linux/macOS スマート起動
├── stop.sh            ← Linux/macOS スマート終了
└── config/            ← 設定ディレクトリ
```

**総サイズ：** 157MB（圧縮）→ 679MB（展開後）

---

## 📋 システム要件

| プラットフォーム | 要件 |
|----------------|------|
| **Windows** | Windows 10 2004+ / Windows 11 |
| **Linux** | Ubuntu 20.04+ / Debian 11+ |
| **macOS** | macOS 10.15+ |
| **USB** | 最低1GBの空き容量 |

---

## ⚠️ セキュリティ注意

**以下のファイルを共有/公開しないでください：**
- `config/openclaw.json` - APIキーを含む
- `data/.last_usb` - パス情報を含む

**権限は自動設定されます：**
- 設定ファイル：`600`（所有者のみ読み書き可能）
- ログファイル：`640`（所有者読み書き、グループ読み取り）

---

## 🔄 アップデート

```bash
# ネットワーク環境で
cd OpenClaw-Portable

# OpenClawを更新
export PATH="$PWD/node/bin:$PWD/npm-global/bin:$PATH"
npm install -g openclaw@latest
```

---

## 📥 ダウンロード

- **GitHub Release**: https://github.com/SonicBotMan/openclaw-portable/releases
- **ミラー（中国向け）**: https://npmmirror.com/mirrors/openclaw-portable/

---

## ❓ よくある質問

<details>
<summary><b>Q: なぜこんなに大きいのですか？</b></summary>

完全なランタイム環境を含むため：
- Node.js ランタイム（192MB）
- OpenClaw + 依存関係（487MB）

これが真のオフライン能力の代償です。
</details>

<details>
<summary><b>Q: 会社のPCで使えますか？</b></summary>

はい！すべてのデータはUSBに保存され、終了後ローカルに痕跡は残りません。
</details>

<details>
<summary><b>Q: 制限されたネットワークで使えますか？</b></summary>

完璧に動作します！VPN不要、ミラー不要、すぐに使えます。
</details>

<details>
<summary><b>Q: どうやってアップデートしますか？</b></summary>

ネットワーク環境で以下を実行：
```bash
export PATH="$PWD/node/bin:$PWD/npm-global/bin:$PATH"
npm install -g openclaw@latest
```
</details>

---

## 🤝 貢献

貢献を歓迎します！[CONTRIBUTING.md](CONTRIBUTING.md)を参照

---

## 📄 ライセンス

MIT License - [LICENSE](LICENSE)を参照

---

## 🌟 Star History

このプロジェクトが役立ったら、⭐️ starをお願いします！

[![Star History Chart](https://api.star-history.com/svg?repos=SonicBotMan/openclaw-portable&type=Date)](https://star-history.com/#SonicBotMan/openclaw-portable&Date)

---

**バージョン：** 4.1.0 | **リリース日：** 2026-03-14 | **Node.js：** v22.14.0 | **OpenClaw：** 2026.3.12

---

<p align="center">
  <b>世界中のAIコミュニティのために ❤️ を込めて作成</b>
</p>
