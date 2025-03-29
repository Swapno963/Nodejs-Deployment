#!/bin/bash

# Writes output(stdout/stderr) to /var/log/setup.log, also display output in terminal
exec > >(tee /var/log/setup.log) 2>&1

# update the system
sudo apt update 

# install nodejs 
sudo apt install nodejs npm -y


# verify installation
node --version
