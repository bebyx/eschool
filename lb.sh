#!/bin/sh

dnf update -y
dnf install httpd -y

firewall-cmd --permanent --add-service=http
firewall-cmd --reload
setenforce 0

cat<<EOF > /etc/httpd/conf.d/lb.conf
<VirtualHost *:80>

Header add Set-Cookie "ROUTEID=.%{BALANCER_WORKER_ROUTE}e; path=/" env=BALANCER_ROUTE_CHANGED

<Proxy *>
    Order deny,allow
    Allow from all
</Proxy>

<Proxy balancer://mycluster>
    BalancerMember http://$APP1_IP$PORT route=backend-1 enablereuse=On
    BalancerMember http://$APP2_IP$PORT route=backend-2 enablereuse=On
    ProxySet lbmethod=bytraffic
    ProxySet stickysession=ROUTEID
</Proxy>

    ProxyPreserveHost On

    ProxyPass "/" "balancer://mycluster/"
    ProxyPassReverse "/" "balancer://mycluster/"
</VirtualHost>
EOF

systemctl start httpd
