#!/bin/sh

dnf update -y
dnf install java-1.8.0-openjdk-devel maven git -y

echo 'JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"' > /etc/profile.d/java.sh
source /etc/profile.d/java.sh

cat <<'EOF' > /etc/profile.d/maven.sh
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF
chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload

git clone https://github.com/yurkovskiy/eSchool

config_file='eSchool/src/main/resources/application.properties'
sed -i -e 's|localhost:3306|192.168.14.89:3306|' $config_file
sed -i -e 's|DATASOURCE_USERNAME:root|DATASOURCE_USERNAME:eschool|' $config_file
sed -i -e 's|DATASOURCE_PASSWORD:root|DATASOURCE_PASSWORD:password|' $config_file
sed -i -e 's|https://fierce-shore-32592.herokuapp.com|http://192.168.14.88:8080|' $config_file

config_prod_file='eSchool/src/main/resources/application-production.properties'
sed -i -e 's|35.242.199.77:3306|192.168.14.89:3306|' $config_prod_file
sed -i -e 's|DATASOURCE_USERNAME:root|DATASOURCE_USERNAME:eschool|' $config_prod_file
sed -i -e 's|DATASOURCE_PASSWORD:CS5eWQxnja0lAESd|DATASOURCE_PASSWORD:password|' $config_prod_file
sed -i -e 's|https://35.240.41.176:8443|http://192.168.14.88:8080|' $config_prod_file

cd eSchool/
mvn clean package -DskipTests

java -jar target/eschool.jar
