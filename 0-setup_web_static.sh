#!/usr/bin/env bash
# Script to install and configure nginx

hostname=$(hostname)

# Update package lists and install nginx
sudo apt update
sudo apt-get -y install nginx

# Allow Nginx HTTP traffic through the firewall
sudo ufw allow 'Nginx HTTP'

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create index.html and custom_404.html
echo "Hello World!" | sudo tee /var/www/html/index.html
echo "Ceci n'est pas une page" | sudo tee /usr/share/nginx/html/custom_404.html

# Create test index.html
sudo printf %s "<html>
<head>
</head>
<body> Hello, this is a test page </body>
</html>" | sudo tee /data/web_static/releases/test/index.html

# Remove existing symlink if exists
if [ -L "/data/web_static/current" ] && [ -e "/data/web_static/current" ]; then
	sudo rm -r "/data/web_static/current"
fi

# Create symlink to current release
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Change ownership of /data directory
sudo chown -R ubuntu:ubuntu /data/

# Configure Nginx
sudo tee /etc/nginx/sites-available/default >/dev/null <<EOF
server {
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
}
EOF

# Restart Nginx
sudo systemctl restart nginx
