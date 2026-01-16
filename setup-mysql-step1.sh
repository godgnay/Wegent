#!/bin/bash

# MySQL 安装步骤 1：修复权限（需要管理员权限）
# 请在终端手动运行此脚本

echo "🔧 修复 Homebrew 权限..."
echo "  这需要管理员权限，请输入你的密码："
echo ""

sudo chown -R $(whoami) /usr/local/etc
chmod u+w /usr/local/etc

echo ""
echo "✅ 权限修复完成！"
echo ""
echo "现在可以运行 ./setup-mysql-step2.sh 继续安装 MySQL"
