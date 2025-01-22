#!/bin/bash

if [[ -z "${MYSQL_DATABASE}" || -z "${MYSQL_USER}" || -z "${MYSQL_PASSWORD}" || -z "${MYSQL_ROOT_PASSWORD}" ]]; then
    echo "Warning: Missing required environment variables. Default values will be used."
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

echo "Creating initialization SQL script..."
cat <<EOF > /tmp/mysql-init.sql
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Starting MariaDB with initialization script..."
exec mysqld --user=mysql --init-file=/tmp/mysql-init.sql
