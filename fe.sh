#!/bin/sh

dnf update -y
dnf install httpd -y

systemctl start httpd

firewall-cmd --permanent --add-service=http
firewall-cmd --reload

mkdir /var/www/eschool
chown -R vagrant:vagrant /var/www/eschool/

tar -xjvf /vagrant/eschool.tar.bz2 -C /var/www/eschool/

cat <<EOF > /etc/httpd/conf.d/eschool.conf
<VirtualHost *:80>
    #ServerName example.com
    #ServerAlias www.example.com
    ServerAdmin webmaster@example.com
    DocumentRoot /var/www/eschool

    <Directory /var/www/eschool>
        Options -Indexes +FollowSymLinks
        AllowOverride All
    </Directory>

    ErrorLog /var/log/httpd/eschool-error.log
    CustomLog /var/log/httpd/eschool-access.log combined
</VirtualHost>
EOF

systemctl restart httpd
