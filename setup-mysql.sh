#!/bin/bash

# MySQL 安装和配置脚本
# 需要管理员权限

set -e

echo "🔧 修复 Homebrew 权限..."
if [ -w /usr/local/etc ]; then
    echo "  ✓ /usr/local/etc 已有写权限"
else
    echo "  ⚠️  需要管理员权限来修复 /usr/local/etc 的权限"
    echo "  请手动执行: sudo chown -R $(whoami) /usr/local/etc"
    echo "  然后再次运行此脚本"
    exit 1
fi

chmod u+w /usr/local/etc 2>/dev/null || true

echo ""
echo "📦 安装 MySQL..."
brew install mysql

echo ""
echo "🚀 启动 MySQL 服务..."
brew services start mysql

echo ""
echo "⏳ 等待 MySQL 启动..."
sleep 5

echo ""
echo "🗄️  创建数据库和用户..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'task_user'@'localhost' IDENTIFIED BY 'task_password';
GRANT ALL PRIVILEGES ON task_manager.* TO 'task_user'@'localhost';
FLUSH PRIVILEGES;
EOF

echo ""
echo "✅ MySQL 安装和配置完成！"
echo ""
echo "现在可以运行 ./start.sh 启动项目了"
