#!/bin/sh

dnf update -y
dnf install httpd -y

firewall-cmd --permanent --add-service=http
firewall-cmd --reload
setenforce 0

cat<<EOF > /etc/httpd/conf.d/lb.conf
<VirtualHost *:80>
<Proxy balancer://mycluster>
    BalancerMember http://192.168.14.88:8080
    BalancerMember http://192.168.14.90:8080
</Proxy>

    ProxyPreserveHost On

    ProxyPass "/" "balancer://mycluster/"
    ProxyPassReverse "/" "balancer://mycluster/"
</VirtualHost>
EOF

systemctl start httpd
