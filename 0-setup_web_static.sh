#!/usr/bin/env bash
# Script to install and configure nginx

# Get the hostname of the machine
hostname=$(hostname)

# Update package lists and upgrade existing packages
sudo apt-get -y update
sudo apt-get -y upgrade

# Install nginx web server
sudo apt-get -y install nginx

# Create necessary directories for web server
sudo mkdir -p /data/web_static/releases/test
sudo mkdir -p /data/web_static/shared

# Create a simple Hello World index page
echo "Hello World!" | sudo tee /var/www/html/index.html

# Create a custom 404 error page
echo "Ceci n'est pas une page" | sudo tee /usr/share/nginx/html/custom_404.html

# Create a test page inside the web_static directory
sudo printf %s "<html>
<head>
</head>
<body> Hello, this is a test page </body>
</html>" | sudo tee /data/web_static/releases/test/index.html

# Remove existing symlink if present and create a new one pointing to the test release
if [ -L "/data/web_static/current" ] && [ -e "/data/web_static/current" ]; then
    rm -r "/data/web_static/current"
fi
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Check if the user 'ubuntu' exists, if not, create it
username="ubuntu"
if id "$username" &>/dev/null; then
    echo "User $username already exists."
else
    sudo useradd -m "$username"
    echo "User $username created."
fi

# Set ownership of web directories to the 'ubuntu' user
sudo chown -hR ubuntu:ubuntu /data/

# Configure nginx default site with appropriate settings
printf %s "server {
        listen 80;
        listen [::]:80;

        server_name $hostname;

        root /var/www/html;

        index index.html;

        error_page 404 /custom_404.html;

        add_header X-Served-By $hostname;

        location = /custom_404.html {
            root /usr/share/nginx/html;
            internal;
        }

        location /redirect_me {
            return 301 http://google.com/;
        }

        location /hbnb_static {
            alias /data/web_static/current/;
        }

        location / {
            try_files \$uri \$uri/ =404;
        }
    }" | sudo tee /etc/nginx/sites-available/default

# Start nginx service
sudo service nginx restart
