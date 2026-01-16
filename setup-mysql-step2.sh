#!/bin/bash

# MySQL 安装步骤 2：安装和配置 MySQL（不需要管理员权限）

set -e

# 检查权限
if [ ! -w /usr/local/etc ]; then
    echo "❌ 错误: /usr/local/etc 没有写权限"
    echo "  请先运行 ./setup-mysql-step1.sh 修复权限"
    exit 1
fi

echo "📦 安装 MySQL..."
brew install mysql

echo ""
echo "🚀 启动 MySQL 服务..."
brew services start mysql

echo ""
echo "⏳ 等待 MySQL 启动（10秒）..."
sleep 10

echo ""
echo "🗄️  创建数据库和用户..."
# 尝试连接 MySQL，可能需要密码
if mysql -u root -e "SELECT 1" >/dev/null 2>&1; then
    # 无密码连接
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'task_user'@'localhost' IDENTIFIED BY 'task_password';
GRANT ALL PRIVILEGES ON task_manager.* TO 'task_user'@'localhost';
FLUSH PRIVILEGES;
EOF
    echo "✅ 数据库和用户创建成功（无密码模式）"
elif mysql -u root -p -e "SELECT 1" >/dev/null 2>&1; then
    echo "⚠️  MySQL root 需要密码，请手动执行以下命令："
    echo ""
    echo "mysql -u root -p <<EOF"
    echo "CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    echo "CREATE USER IF NOT EXISTS 'task_user'@'localhost' IDENTIFIED BY 'task_password';"
    echo "GRANT ALL PRIVILEGES ON task_manager.* TO 'task_user'@'localhost';"
    echo "FLUSH PRIVILEGES;"
    echo "EOF"
    exit 1
else
    echo "❌ 无法连接到 MySQL"
    echo "  请检查 MySQL 是否已启动: brew services list"
    exit 1
fi

echo ""
echo "✅ MySQL 安装和配置完成！"
echo ""
echo "现在可以运行 ./start.sh 启动项目了"
