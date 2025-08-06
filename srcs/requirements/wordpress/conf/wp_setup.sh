#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
    sleep 2
done

echo "MariaDB is ready!"

# Download and install WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    echo "Installing WP-CLI..."
    curl -o wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Check if WordPress is already installed
if ! wp core is-installed --allow-root --path=/var/www/html; then
    echo "Installing WordPress..."
    
    # Install WordPress
    wp core install \
        --url="https://${SERVER_NAME}" \
        --title="My Inception Site" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root \
        --path=/var/www/html

    # Create additional user
    wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --role=subscriber \
        --user_pass="${WORDPRESS_USER_PASSWORD}" \
        --allow-root \
        --path=/var/www/html

    echo "WordPress installation and user creation complete!"
else
    echo "WordPress is already installed."
fi

# Start PHP-FPM
exec php-fpm8.2 --nodaemonize