#!/bin/bash

# Writes output(stdout/stderr) to /var/log/setup.log, also displays output in terminal
exec > >(tee /var/log/setup.log) 2>&1

# MySQL setup for database, user, table, and sample data
MYSQL_ROOT_PASSWORD="root"
DATABASE_NAME="practice_app"
DB_USER="sample_user"
DB_PASSWORD="Str0ng!Pass123"

# MySQL commands to create database, user, table, and sample data
sudo mysql -u root   <<EOF

# Create a new database
CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;

# Create a new MySQL user if not exists and set a password
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';

# Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DB_USER'@'%';

# Apply privilege changes
FLUSH PRIVILEGES;

# Show databases to verify if the database is created
SHOW DATABASES;

# Create a new table
USE $DATABASE_NAME;
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

# Insert sample data into the users table
INSERT INTO users (name, email) VALUES ('Swapno Mondol', 'swapno@admin.com');
INSERT INTO users (name, email) VALUES ('Sumit Saha', 'sumit@saha.com');
INSERT INTO users (name, email) VALUES ('Shuvo Saha', 'Shuvo@saha.com');

# Show the created table and data
SELECT * FROM users;

EOF

echo "Database '$DATABASE_NAME' and user '$DB_USER' created with sample data."
