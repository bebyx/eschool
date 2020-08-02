#!/bin/sh

#Update CentOS8 and install needed packages
dnf update -y
dnf install mariadb-server -y

# Start and enable on boot MariaDB server
systemctl start mariadb
systemctl enable mariadb

# Run mysql_secure_installation script
mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

# Create web app database and asign user
mysql -u root <<-EOF
CREATE DATABASE eschool DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;
GRANT ALL ON eschool.* TO 'eschool'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Let database be publicly reachable
sed -i.bak '/bind-address/ s/#bind-address=127.0.0.1/bind-address=0.0.0.0/' /etc/my.cnf.d/mariadb-server.cnf
systemctl restart mariadb

# Open mysql 3306 port for db to be reached by backend VM
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --reload
