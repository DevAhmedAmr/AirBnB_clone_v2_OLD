#!/usr/bin/env bash
#script to install and configue nginx
hostname=$(hostname)
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install nginx

sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

echo "Hello World!" >/var/www/html/index.html
echo "Ceci n'est pas une page" >/usr/share/nginx/html/custom_404.html

sudo printf %s "<html>
<head>
</head>
<body> Hello,this is a test page </body>
</html>" >/data/web_static/releases/test/index.html

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
        internal;}

        location /redirect_me {
            return 301 http://google.com/;
                                            }
        location /hbnb_static{
            alias /data/web_static/current/;}

        location / {
            try_files \$uri \$uri/ =404;
            }
        }" >/etc/nginx/sites-available/default

sudo systemctl restart nginx
