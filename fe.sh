#!/bin/sh

# Update CentOS8 and install needed packages
dnf update -y
dnf install httpd git nodejs wget bzip2 -y

# Start Apache web server
systemctl start httpd

npm i -g yarn
npm i -g @angular/cli

git clone https://github.com/yurkovskiy/final_project.git
sed -i "/baseUrl/ s|'https\?://.*'|'http://$LB_BE_EXT_IP'|" /home/bebyx/final_project/src/app/services/token-interceptor.service.ts

cd final_project/
/usr/local/bin/yarn install
/usr/local/bin/ng build --prod
chown -R bebyx:bebyx /home/bebyx/final_project/

# Open http (port 80) for public
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
setenforce 0

# Create and assign frontend Apache folder
mkdir /var/www/eschool

# Copy frontend files into Apache folder
cp -r /home/bebyx/final_project/dist/eSchool/* /var/www/eschool/
wget "https://dtapi.if.ua/~yurkovskiy/IF-108/htaccess_example_fe" -O /var/www/eschool/.htaccess
chown -R bebyx:bebyx /var/www/eschool/

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

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

dnf install -y epel-release && dnf update -y
dnf install incron -y

echo '# Jenkins server key, added by Vagrant script' >> /home/bebyx/.ssh/authorized_keys
echo -e "$SSH_PUB_INSTANCE" >> /home/bebyx/.ssh/authorized_keys

mkdir /home/bebyx/CI
chown -R bebyx:bebyx /home/bebyx/CI

cat <<-EOF > /home/bebyx/restarter.sh
#!/bin/sh

tar -xjvf /home/bebyx/CI/artefacts.tar.bz2 -C /home/bebyx/
systemctl stop httpd
rm -r /var/www/eschool/*
wget "https://dtapi.if.ua/~yurkovskiy/IF-108/htaccess_example_fe" -O /var/www/eschool/.htaccess

cp -R /home/bebyx/dist/eSchool/* /var/www/eschool/
chown -R bebyx:bebyx /var/www/eschool

systemctl start httpd
exit
EOF

chmod +x /home/bebyx/restarter.sh

echo -e '/home/bebyx/CI\tIN_CLOSE_WRITE\t/home/bebyx/restarter.sh' > /var/spool/incron/root
chmod 600 /var/spool/incron/root
incrontab -d

systemctl start incrond
