#!/bin/sh

firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload
setenforce 0

dnf update -y
dnf install wget git maven java-1.8.0-openjdk nodejs bzip2 -y

echo 'JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"' > /etc/profile.d/java.sh
source /etc/profile.d/java.sh

npm i -g yarn
npm i -g @angular/cli

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
dnf install jenkins -y

systemctl start jenkins
systemctl enable jenkins
sleep 120

# Download jenkins-cli for CLI commands
wget http://localhost:8080/jnlpJars/jenkins-cli.jar

# Create Jenkins admin user
echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "admin")' | sudo java -jar jenkins-cli.jar -s "http://localhost:8080" -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` -noKeyAuth groovy =

# Install basic plugins and maven-plugin
java -jar jenkins-cli.jar -s "http://localhost:8080" -auth admin:admin install-plugin maven-plugin trilead-api jdk-tool workflow-support script-security command-launcher workflow-cps bouncycastle-api handlebars  locale javadoc momentjs structs workflow-step-api scm-api workflow-api junit apache-httpcomponents-client-4-api pipeline-input-step display-url-api mailer credentials ssh-credentials jsch maven-plugin git-server token-macro pipeline-stage-step run-condition matrix-project conditional-buildstep parameterized-trigger git git-client workflow-scm-step cloudbees-folder timestamper pipeline-milestone-step workflow-job jquery-detached jackson2-api branch-api ace-editor pipeline-graph-analysis pipeline-rest-api pipeline-stage-view pipeline-build-step plain-credentials credentials-binding pipeline-model-api pipeline-model-extensions workflow-cps-global-lib workflow-multibranch authentication-tokens docker-commons durable-task workflow-durable-task-step workflow-basic-steps docker-workflow pipeline-stage-tags-metadata pipeline-model-declarative-agent pipeline-model-definition workflow-aggregator lockable-resources github -deploy

# Let Jenkins know about system Maven
cat <<-EOF > /var/lib/jenkins/hudson.tasks.Maven.xml
<?xml version='1.1' encoding='UTF-8'?>
<hudson.tasks.Maven_-DescriptorImpl>
  <installations>
    <hudson.tasks.Maven_-MavenInstallation>
      <name>M3</name>
      <home>/usr/share/maven</home>
      <properties/>
    </hudson.tasks.Maven_-MavenInstallation>
  </installations>
</hudson.tasks.Maven_-DescriptorImpl>
EOF

# Creating jenkins ssh keys
mkdir /var/lib/jenkins/.ssh
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh/
echo -e "$SSH_KEY_INSTANCE" > /var/lib/jenkins/.ssh/id_rsa
echo -e "$SSH_PUB_INSTANCE" > /var/lib/jenkins/.ssh/id_rsa.pub
chown jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa
chown jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa.pub
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa.pub

# Restart Jenkins server to enable new configs
java -jar jenkins-cli.jar -s "http://localhost:8080" -auth admin:admin safe-restart
systemctl restart jenkins
sleep 120

# Import Jenkins jobs
java -jar jenkins-cli.jar -s "http://localhost:8080" -auth admin:admin create-job eschool < /vagrant/eschool.xml
java -jar jenkins-cli.jar -s "http://localhost:8080" -auth admin:admin create-job eschool_js < /vagrant/eschool_js.xml

# Build backend job
java -jar jenkins-cli.jar -s "http://localhost:8080" -auth admin:admin build eschool

# Build frontend job
java -jar jenkins-cli.jar -s "http://localhost:8080" -auth admin:admin build eschool_js
