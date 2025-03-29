#!/bin/bash


# Writes output(stdout/stderr) to /var/log/setup.log, also display output in terminal
exec > >(tee /var/log/setup.log) 2>&1

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Packages to check whether they are installed or not
necessary_packages=("mysql" "node" "npm")

# storeing base directory for later useage
BASE_DIR=$(pwd)

# Check whether we have installed those
for package in "${necessary_packages[@]}"; do
    if command_exists "$package"; then
        echo "$package is already installed!"
    else
        echo "We need to install $package"
        
        if [ "$package" = "node" ]; then
            echo "Installing Node.js"
            $BASE_DIR/install_nodejs.sh
        elif [ "$package" = "npm" ]; then
            echo "Installing npm"
            $BASE_DIR/install_npm.sh
        elif [ "$package" = "mysql" ]; then
            echo "Installing MySQL"
            $BASE_DIR/install_mysql.sh
    
        fi
    fi
done
$BASE_DIR/mysql-check.sh
