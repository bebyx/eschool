#!/bin/sh

dnf update -y
dnf install nginx -y

firewall-cmd --permanent --add-service=http
firewall-cmd --reload
setenforce 0

cat<<EOF > /etc/nginx/conf.d/lb.conf
upstream app {
  ip_hash;
  server $APP1_IP$PORT;
  server $APP2_IP$PORT;
}

server {
        listen 80 default_server;
        listen [::]:80 default_server;

        location / {
            proxy_pass http://app;
        }
}
EOF

sed -i "s|\s*default_server||g" /etc/nginx/nginx.conf

systemctl start nginx
