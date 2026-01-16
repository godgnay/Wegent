# MySQL 数据库配置说明

## 创建数据库和用户

请在终端执行以下命令（会提示输入 MySQL root 密码）：

```bash
/usr/local/mysql-9.5.0-macos15-arm64/bin/mysql -u root -p <<EOF
CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'task_user'@'localhost' IDENTIFIED BY 'task_password';
GRANT ALL PRIVILEGES ON task_manager.* TO 'task_user'@'localhost';
FLUSH PRIVILEGES;
EOF
```

或者，你也可以一行一行执行：

```bash
# 1. 连接到 MySQL（会提示输入 root 密码）
/usr/local/mysql-9.5.0-macos15-arm64/bin/mysql -u root -p

# 2. 在 MySQL 提示符下执行以下 SQL 命令：
CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'task_user'@'localhost' IDENTIFIED BY 'task_password';
GRANT ALL PRIVILEGES ON task_manager.* TO 'task_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 验证配置

执行以下命令验证数据库和用户是否创建成功：

```bash
/usr/local/mysql-9.5.0-macos15-arm64/bin/mysql -u task_user -ptask_password -e "USE task_manager; SELECT 1;"
```

如果看到输出 `1`，说明配置成功！

## 完成后

运行 `./start.sh` 启动项目。
