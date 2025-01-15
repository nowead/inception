#!/bin/sh

wp core download --allow-root

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i -r "s/database_name_here/$MYSQL_DATABASE/1"   wp-config.php
sed -i -r "s/username_here/$MYSQL_USER/1"  wp-config.php
sed -i -r "s/password_here/$MYSQL_PASSWORD/1"    wp-config.php
sed -i -r "s/localhost/mariadb:3306/1"    wp-config.php

echo "Installing WordPress..."
wp core install --url=$DOMAIN_NAME --title="$WP_TITLE" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
echo "WordPress installed successfully."

echo "Creating additional WordPress user..."
wp user create $WP_USER $WP_EMAIL --role=subscriber --user_pass=$WP_PASSWORD --allow-root
echo "Additional user created."

mkdir -p /run/php

echo "Starting PHP-FPM for WordPress..."

echo "========================================="
echo "WordPress setup completed successfully!"
echo "You can now access your site at: $DOMAIN_NAME"
echo "========================================="

if /usr/sbin/php-fpm8.2 -F; then
    echo "PHP-FPM is running successfully."
else
    echo "========================================="
    echo "Error: PHP-FPM failed to start."
    echo "Please check the configuration and logs for more details."
    echo "========================================="
    exit 1
fi
