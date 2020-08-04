#!/bin/sh

# Update CentOS8 and install needed packages
dnf update -y
dnf install httpd git nodejs wget -y

# Start Apache web server
systemctl start httpd

npm i -g yarn
npm i -g @angular/cli

git clone https://github.com/yurkovskiy/final_project.git
chown vagrant:vagrant /home/vagrant/final_project
cd final_project/
/usr/local/bin/yarn install
/usr/local/bin/ng build --prod

sed -i "/baseUrl/ s|'https\?://.*'|'http:$LB_BE_IP'|" /home/vagrant/final_project/src/app/services/token-interceptor.service.ts

# Open http (port 80) for public
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
setenforce 0

# Create and assign frontend Apache folder
mkdir /var/www/eschool
chown -R vagrant:vagrant /var/www/eschool/

# Copy frontend files into Apache folder
cp -r /home/vagrant/final_project/dist/eSchool/* /var/www/eschool/
wget "https://dtapi.if.ua/~yurkovskiy/IF-108/htaccess_example_fe" -O /var/www/eschool/.htaccess

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
