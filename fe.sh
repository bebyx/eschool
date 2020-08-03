#!/bin/sh

# Update CentOS8 and install needed packages
dnf update -y
dnf install httpd -y

# Start Apache web server
systemctl start httpd

# Open http (port 80) for public
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Create and assign frontend Apache folder
mkdir /var/www/eschool
chown -R vagrant:vagrant /var/www/eschool/

# Unarchive frontend files into Apache folder
tar -xjvf /vagrant/eschool.tar.bz2 -C /var/www/eschool/

# Add VirtualHost for the web instance
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

# Restart Apache to enable new config
systemctl restart httpd
