#!/bin/sh

dnf update -y
dnf install mariadb-server -y

systemctl start mariadb
systemctl enable mariadb

mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

mysql -u root <<-EOF
CREATE DATABASE eschool DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;
GRANT ALL ON eschool.* TO 'eschool'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

sed -i.bak '/bind-address/ s/127.0.0.1/0.0.0.0/' /etc/my.cnf.d/mariadb-server.cnf

systemctl restart mariadb
