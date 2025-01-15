#!/bin/bash

if [[ -z "${MYSQL_DATABASE}" || -z "${MYSQL_USER}" || -z "${MYSQL_PASSWORD}" || -z "${MYSQL_ROOT_PASSWORD}" ]]; then
    echo "Warning: Missing required environment variables. Default values will be used."
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting MariaDB temporarily..."
mysqld_safe --user=mysql &
sleep 10

echo "Setting up database and user..."
mysql -u root --execute="CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -u root --execute="CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root --execute="GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -u root --execute="FLUSH PRIVILEGES;"

echo "Shutting down temporary MariaDB..."
mysqladmin -uroot shutdown

echo "Starting MariaDB foreground process..."
exec mysqld_safe --user=mysql
