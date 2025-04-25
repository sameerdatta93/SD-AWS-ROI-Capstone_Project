#!/bin/bash 
sudo yum update -y
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

cat <<EOF > /usr/share/nginx/html/index.html
<html>
  <head><title>Feedback App</title></head>
  <body>
    <h1>Welcome to the Feedback App</h1>
  </body>
</html>
EOF

