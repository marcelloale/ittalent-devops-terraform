#!/bin/bash
sudo apt update -y &&
sudo apt install -y nginx
service nginx start
cat <<EOH > /etc/nginx/sites-available/default
server {
    listen 80;
    location / {
    proxy_pass http://ittalent-terraform-23.s3-website-sa-east-1.amazonaws.com/;
    }
}
EOH
sudo systemctl reload nginx
EOF