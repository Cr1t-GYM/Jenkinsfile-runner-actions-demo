#!/usr/bin/env bash

set -e
#rm -rf /usr/share/jenkins/ref/plugins
#echo "p1"
#unzip /app/jenkins-${JENKINS_VERSION}.war -d /app/jenkins-${JENKINS_VERSION}
#TODO: download latest plugins/minimum required version plugins will cause exception.
#TODO: use the self-contained war will cause exception but can run the pipeline.
echo "p2"
java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file "$2" --plugin-download-directory=/usr/share/jenkins/ref/plugins
echo "p3"
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins -p /usr/share/jenkins/ref/plugins -f "$3"