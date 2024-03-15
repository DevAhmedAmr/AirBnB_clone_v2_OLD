#!/usr/bin/env bash
#script to install and configue nginx
hostname=$(hostname)
sudo apt update -y
sudo apt-get -y install nginx
sudo ufw app list
sudo ufw allow 'Nginx HTTP'

sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

if [ -L "/data/web_static/current" ] && [ -e "/data/web_static/current" ]; then
    rm -r "/data/web_static/current"
fi

sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Check if the user exists
username="ubuntu"

if id "$username" &>/dev/null; then
    echo "User $username already exists."
else
    # Create the user
    sudo useradd -m "$username"
    echo "User $username created."
fi

sudo chown -R ubuntu:ubuntu /data/

sudo systemctl restart nginx
