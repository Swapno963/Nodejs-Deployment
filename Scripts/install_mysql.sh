#!/bin/bash


# Writes output(stdout/stderr) to /var/log/setup.log, also display output in terminal
exec > >(tee /var/log/setup.log) 2>&1


# update the system
sudo apt update 
apt upgrade -y

# install mysql server
sudo apt install mysql-server -y


# start and enable mysql
sudo systemctl start mysql
suso systemctl enable mysql

# # secure mysql 
sudo mysql_secure_installation
# comment(){
# it helps improve security by:

# Setting a Root Password : Ensures that the MySQL root user is protected.
# Removing Anonymous Users : Prevents unauthorized access to MySQL.
# Disabling Remote Root Login : Stops root access from outside the local machine.
# Removing Test Databases : Deletes unnecessary databases that could be a security risk.
# Reloading Privilege Tables : Ensures changes take effect immediately.
# }

# verify installation
mysql --version



echo "Verifing MySql listening port"
# it will show -t: tcp connections, -u: udp connection, -l: show listening ports, -n: show addresses numerically, -p: show the process name and pid that owns the port
sudo netstat -tulnp | grep mysql


echo "Modifing mysql configuration file to allow remote connections"
sed -i 's/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf



echo "Again, verifing MySql listening port"
sudo netstat -tulnp | grep mysql
