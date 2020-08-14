#!/bin/bash

# Update CentOS8 and install needed packages
dnf update -y
dnf install java-1.8.0-openjdk-devel maven git -y

# Set JAVE_HOME
echo 'JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"' > /etc/profile.d/java.sh
source /etc/profile.d/java.sh

# Set MAVEN_HOME
cat <<'EOF' > /etc/profile.d/maven.sh
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF
chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

# Open 8080 port to reach web app from the host machine
firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload
setenforce 0

# Clone web app source
git clone https://github.com/yurkovskiy/eSchool
chown -R bebyx:bebyx eSchool/

# Function to change app config files: $1 is existing pattern, $2 is our input, $3 is config file path.
function edit_config() {
  sed -i -e "s|$1|$2|" $3
}
config_file='eSchool/src/main/resources/application.properties'
config_prod_file='eSchool/src/main/resources/application-production.properties'

edit_config localhost:3306 $DB_IP:3306 $config_file
edit_config DATASOURCE_USERNAME:root DATASOURCE_USERNAME:eschool $config_file
edit_config DATASOURCE_PASSWORD:root DATASOURCE_PASSWORD:password $config_file
edit_config https://fierce-shore-32592.herokuapp.com http://$APP_IP:8080 $config_file

edit_config 35.242.199.77:3306 $DB_IP:3306 $config_prod_file
edit_config DATASOURCE_USERNAME:root DATASOURCE_USERNAME:eschool $config_prod_file
edit_config DATASOURCE_PASSWORD:CS5eWQxnja0lAESd DATASOURCE_PASSWORD:password $config_prod_file
edit_config https://35.240.41.176:8443 http://$APP_IP:8080 $config_prod_file

# Use Maven to build .jar package
cd eSchool/
mvn clean package -DskipTests

# Launch web app
java -jar target/eschool.jar > eschool.log &

#+++++++++++++++++++++++++++++++++++++++++++++++++
dnf install -y epel-release && dnf update -y
dnf install incron -y

mkdir /home/bebyx/CI
chown -R bebyx:bebyx /home/bebyx/CI

cat <<-EOF > /home/bebyx/restarter.sh
#!/bin/sh

pkill java
cp -R /home/bebyx/CI/eschool.jar /home/bebyx/eSchool/target/eschool.jar
java -jar /home/bebyx/eSchool/target/eschool.jar --spring.config.location=file:///home/bebyx/eSchool/src/main/resources/application.properties > /home/bebyx/eschool2.log &2>/home/bebyx/eschool2err.log &

exit
EOF
chmod +x /home/bebyx/restarter.sh

echo -e '/home/bebyx/CI\tIN_CLOSE_WRITE\t/home/bebyx/restarter.sh' > /var/spool/incron/root
chmod 600 /var/spool/incron/root
incrontab -d

systemctl start incrond

# ADD SYSTEMD UNIT
#systemctl start .updater.sh
