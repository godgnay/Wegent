#!/bin/bash

# MySQL 数据库配置脚本
# 创建 task_manager 数据库和用户

set -e

MYSQL_BIN="/usr/local/mysql-9.5.0-macos15-arm64/bin/mysql"

if [ ! -f "$MYSQL_BIN" ]; then
    echo "❌ 错误: 找不到 MySQL 可执行文件"
    echo "   请检查 MySQL 安装路径"
    exit 1
fi

echo "🗄️  创建数据库和用户..."
echo ""
echo "请输入 MySQL root 密码（如果设置了密码）:"
echo "（如果没有设置密码，直接按回车）"
echo ""

# 尝试无密码连接
if $MYSQL_BIN -u root -e "SELECT 1" >/dev/null 2>&1; then
    echo "✓ 使用无密码模式连接"
    $MYSQL_BIN -u root <<EOF
CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'task_user'@'localhost' IDENTIFIED BY 'task_password';
GRANT ALL PRIVILEGES ON task_manager.* TO 'task_user'@'localhost';
FLUSH PRIVILEGES;
EOF
    echo ""
    echo "✅ 数据库和用户创建成功！"
elif $MYSQL_BIN -u root -p <<EOF
CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'task_user'@'localhost' IDENTIFIED BY 'task_password';
GRANT ALL PRIVILEGES ON task_manager.* TO 'task_user'@'localhost';
FLUSH PRIVILEGES;
EOF
then
    echo ""
    echo "✅ 数据库和用户创建成功！"
else
    echo ""
    echo "❌ 创建失败，请手动执行以下命令："
    echo ""
    echo "$MYSQL_BIN -u root -p <<EOF"
    echo "CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    echo "CREATE USER IF NOT EXISTS 'task_user'@'localhost' IDENTIFIED BY 'task_password';"
    echo "GRANT ALL PRIVILEGES ON task_manager.* TO 'task_user'@'localhost';"
    echo "FLUSH PRIVILEGES;"
    echo "EOF"
    exit 1
fi

echo ""
echo "验证连接..."
if $MYSQL_BIN -u task_user -ptask_password -e "USE task_manager; SELECT 1;" >/dev/null 2>&1; then
    echo "✅ 验证成功！数据库配置完成"
    echo ""
    echo "现在可以运行 ./start.sh 启动项目了"
else
    echo "⚠️  验证失败，请检查配置"
    exit 1
fi
