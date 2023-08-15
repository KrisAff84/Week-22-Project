#!/bin/bash
apt update
apt install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>This EC2 instance was deployed with Terraform via a user data file</h1>" >> /var/www/html/index.html
