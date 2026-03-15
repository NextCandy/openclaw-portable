#!/usr/bin/env node
/**
 * OpenClaw Portable - 模型配置合并工具
 * 
 * 功能：
 * 1. 读取 data/.openclaw/models.json（增量配置）
 * 2. 读取 data/.openclaw/openclaw.json（现有配置）
 * 3. 智能合并（只更新 models 相关字段）
 * 4. 备份原配置
 * 5. 写入新配置
 * 
 * 用法：
 *   node install-models.js
 * 
 * 或通过 batch 文件：
 *   apply-config.bat
 */

const fs = require('fs');
const path = require('path');

// 配置路径
const CONFIG_DIR = path.join(__dirname, 'data', '.openclaw');
const MODELS_FILE = path.join(__dirname, 'models.json');  // 从根目录读取
const CONFIG_FILE = path.join(CONFIG_DIR, 'openclaw.json');
const BACKUP_DIR = path.join(CONFIG_DIR, 'backups');

// 颜色输出
const colors = {
    reset: '\x1b[0m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    red: '\x1b[31m',
    cyan: '\x1b[36m'
};

function log(msg, color = 'reset') {
    console.log(`${colors[color]}${msg}${colors.reset}`);
}

/**
 * 深度合并对象（只合并源对象中存在的字段）
 */
function deepMerge(target, source) {
    const result = JSON.parse(JSON.stringify(target)); // 深拷贝
    
    for (const key in source) {
        if (source.hasOwnProperty(key)) {
            if (typeof source[key] === 'object' && source[key] !== null && !Array.isArray(source[key])) {
                // 递归合并对象
                result[key] = deepMerge(result[key] || {}, source[key]);
            } else {
                // 直接覆盖
                result[key] = source[key];
            }
        }
    }
    
    return result;
}

/**
 * 创建备份
 */
function createBackup(config) {
    if (!fs.existsSync(BACKUP_DIR)) {
        fs.mkdirSync(BACKUP_DIR, { recursive: true });
    }
    
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    const backupFile = path.join(BACKUP_DIR, `openclaw-${timestamp}.json`);
    
    fs.writeFileSync(backupFile, JSON.stringify(config, null, 2));
    log(`✅ 备份已创建: ${backupFile}`, 'green');
    
    return backupFile;
}

/**
 * 主函数
 */
function main() {
    log('\n🦞 OpenClaw 模型配置合并工具\n', 'cyan');
    
    // 1. 检查 models.json 是否存在
    if (!fs.existsSync(MODELS_FILE)) {
        log('❌ 错误: 未找到 models.json', 'red');
        log('   请先使用 config.html 生成配置文件\n', 'yellow');
        process.exit(1);
    }
    
    // 2. 读取增量配置
    log('📋 读取增量配置...', 'cyan');
    const modelsConfig = JSON.parse(fs.readFileSync(MODELS_FILE, 'utf8'));
    
    // 3. 检查 openclaw.json 是否存在
    if (!fs.existsSync(CONFIG_FILE)) {
        log('⚠️  未找到现有配置，将创建新配置', 'yellow');
        var currentConfig = {};
    } else {
        log('📋 读取现有配置...', 'cyan');
        var currentConfig = JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));
    }
    
    // 4. 显示将要合并的字段
    log('\n📦 将要合并的字段:', 'cyan');
    const mergeFields = Object.keys(modelsConfig);
    mergeFields.forEach(field => {
        log(`   - ${field}`, 'green');
    });
    
    // 5. 备份原配置
    if (Object.keys(currentConfig).length > 0) {
        log('\n💾 备份原配置...', 'cyan');
        createBackup(currentConfig);
    }
    
    // 6. 智能合并
    log('\n🔄 合并配置...', 'cyan');
    const mergedConfig = deepMerge(currentConfig, modelsConfig);
    
    // 7. 写入新配置
    fs.writeFileSync(CONFIG_FILE, JSON.stringify(mergedConfig, null, 2));
    log('✅ 配置已更新', 'green');
    
    // 8. 删除临时文件
    fs.unlinkSync(MODELS_FILE);
    log('🗑️  已清理临时文件', 'green');
    
    // 9. 显示成功信息
    log('\n✅ 配置合并完成！\n', 'green');
    log('下一步:', 'cyan');
    log('  1. 运行 restart.bat 重启 Gateway', 'yellow');
    log('  2. 或运行 start.bat 启动 Gateway\n', 'yellow');
}

// 执行
try {
    main();
} catch (error) {
    log(`\n❌ 错误: ${error.message}`, 'red');
    console.error(error);
    process.exit(1);
}
