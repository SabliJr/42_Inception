#!/bin/sh

echo "starting the db setup script"

mysqld_safe &

until mysqladmin ping >/dev/null 2>&1; do
    sleep 5
    echo "Waiting for the database to connect..."
done

echo "The db has started."

# Create the DB
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Secure root
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

echo "Database setup complete."

mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
echo "MySQL server shutting down."

exec mysqld_safe
