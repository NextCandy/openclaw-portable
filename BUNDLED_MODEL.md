# 🤖 Built-in Local Model Support

OpenClaw Portable v6.0.0+ comes with a **built-in CPU-only local AI model**, enabling truly offline AI assistance with zero API costs.

---

## 📦 What's Included

### Model: Qwen2.5-1.5B-Instruct Q4_K_M

| Attribute | Value |
|-----------|-------|
| **Model Size** | ~900 MB |
| **RAM Usage** | ~1.2 GB |
| **Inference Engine** | llama.cpp `llama-server` (static binary, no install) |
| **Tool Calling** | ✅ Native support |
| **Context Window** | 32k tokens |
| **CPU Speed (4-core)** | ~8-12 tok/s |
| **License** | Apache 2.0 ✅ redistributable |

This is the smallest model with **reliable tool-calling support**, which OpenClaw's agent runtime requires.

---

## 🚀 How It Works

### Automatic Model Detection

When you run `start.bat` or `start.sh`, OpenClaw Portable automatically:

1. **Detects** if llama-server binary and model file exist
2. **Starts** llama-server on port 18080 (if available)
3. **Registers** the model as `bundled-local/qwen2.5-1.5b`
4. **Sets as default** if no primary model is configured

### Graceful Degradation

If the bundled model is not found:
- ✅ OpenClaw still starts normally
- ✅ Cloud API models remain available
- ℹ️ User sees a warning message

---

## 📁 Directory Structure

```
openclaw-portable/
├── llm/
│   ├── bin/
│   │   ├── llama-server-linux-x86_64
│   │   ├── llama-server-macos-arm64
│   │   ├── llama-server-macos-x86_64
│   │   └── llama-server-win32-avx2.exe
│   ├── models/
│   │   └── qwen2.5-1.5b-instruct-q4_k_m.gguf
│   ├── server.log
│   └── server.pid
```

---

## ⚙️ Configuration

### Auto-Injected Model Provider

The bundled model is automatically registered in `openclaw.json`:

```json
{
  "models": {
    "providers": {
      "bundled-local": {
        "baseUrl": "http://127.0.0.1:18080/v1",
        "apiKey": "bundled-no-key",
        "api": "openai-completions",
        "models": [
          {
            "id": "qwen2.5-1.5b",
            "name": "Qwen2.5 1.5B (Bundled CPU)",
            "contextWindow": 32768,
            "maxTokens": 4096,
            "cost": { "input": 0, "output": 0 }
          }
        ]
      }
    }
  }
}
```

### Default vs Fallback

- **No primary model configured**: Bundled model becomes default
- **Primary model already configured**: Bundled model acts as fallback

---

## 🎯 Performance Expectations

### CPU Requirements

| CPU | Speed | First Response |
|-----|-------|----------------|
| **4-core** | 8-12 tok/s | 5-10 seconds |
| **8-core** | 12-18 tok/s | 5-8 seconds |
| **16-core** | 15-22 tok/s | 3-5 seconds |

### Memory Requirements

- **Minimum**: 2 GB RAM
- **Recommended**: 4 GB RAM
- **Model Loading**: ~1.2 GB RAM

---

## 🔧 Manual Control

### Check if Model is Running

**Windows:**
```batch
netstat -ano | findstr :18080
```

**Linux/macOS:**
```bash
lsof -i :18080
```

### Stop the Model

Run `stop.bat` or `stop.sh`, which automatically stops llama-server.

### Manual Start (if needed)

**Windows:**
```batch
cd llm\bin
llama-server-win32-avx2.exe --model ..\models\qwen2.5-1.5b-instruct-q4_k_m.gguf --port 18080 --host 127.0.0.1 --ctx-size 32768
```

**Linux/macOS:**
```bash
cd llm/bin
./llama-server-linux-x86_64 --model ../models/qwen2.5-1.5b-instruct-q4_k_m.gguf --port 18080 --host 127.0.0.1 --ctx-size 32768
```

---

## ❓ FAQ

### Q: Why is the model so slow?
**A:** The bundled model runs on CPU only. For faster inference:
- Use a machine with more cores
- Close other CPU-intensive applications
- Consider using a GPU-based model instead

### Q: Can I use a different model?
**A:** Yes! You can:
1. Replace `llm/models/*.gguf` with your own GGUF model
2. Update the model filename in `start.sh` / `start.bat`
3. Restart OpenClaw

### Q: What if my CPU doesn't support AVX2?
**A:** The Windows binary requires AVX2 support. On older CPUs:
- Use the Linux/macOS versions (more compatible)
- Or use cloud API models instead

### Q: Can I disable the bundled model?
**A:** Yes, simply:
1. Delete or rename the `llm/` directory
2. OpenClaw will skip the bundled model startup

---

## 🚀 Benefits

| Feature | Cloud API | Bundled Model |
|---------|-----------|---------------|
| **Offline** | ❌ No | ✅ Yes |
| **Zero Cost** | ❌ No | ✅ Yes |
| **Privacy** | ⚠️ Data sent to cloud | ✅ All local |
| **Speed** | ✅ Fast | ⚠️ Slower |
| **Quality** | ✅ Best models | ⚠️ Smaller model |

---

## 📥 Downloading the Model

The model is included in the offline package. If you need to download it separately:

```bash
# Download Qwen2.5-1.5B-Instruct Q4_K_M (~900MB)
curl -L -o llm/models/qwen2.5-1.5b-instruct-q4_k_m.gguf \
  https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf
```

---

**OpenClaw Portable - Your AI, Your Data, Everywhere, Even Offline!** 🚀
