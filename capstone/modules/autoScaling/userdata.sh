#!/bin/bash

# Update and install required packages
dnf update -y
dnf install -y nginx git
dnf module enable -y nodejs:18
dnf install -y nodejs

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

cd /home/ec2-user
git clone https://github.com/sameerdatta93/feedback-collection-system.git feedback-collection-system
cd feedback-collection-system
cp -r frontend/* /usr/share/nginx/html/

cat > /etc/nginx/nginx.conf <<EOF
events {}
http {
    include       mime.types;
    default_type  application/octet-stream;

    server {
        listen 80;
        server_name localhost;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        location /feedback {
            proxy_pass http://localhost:3000/feedback;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
        }
    }
}
EOF

# Restart nginx to apply new config
systemctl stop nginx
sleep 10
systemctl start nginx

# Start backend
cd backend
npm install
