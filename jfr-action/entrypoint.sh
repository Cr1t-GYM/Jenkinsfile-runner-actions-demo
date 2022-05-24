#!/usr/bin/env bash

set -e
rm -rf /usr/share/jenkins/ref/plugins
echo "p1"
#unzip /app/jenkins-${JENKINS_VERSION}.war -d /app/jenkins-${JENKINS_VERSION}
#unzip /app/jenkins/jenkins.war -d /app/jenkins
echo "p2"
java -jar /app/bin/jenkins-plugin-manager.jar --war /jenkinsfile-runner/vanilla-package/target/war/jenkins.war --plugin-file "$2" --plugin-download-directory=/usr/share/jenkins/ref/plugins
echo "p3"
/app/bin/jenkinsfile-runner-launcher "$1" -w /jenkinsfile-runner/vanilla-package/target/war/jenkins.war -p /usr/share/jenkins/ref/plugins -f "$3"