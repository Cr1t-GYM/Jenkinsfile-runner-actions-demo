#!/usr/bin/env bash

set -e

java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file "$2" --plugin-download-directory=/usr/share/jenkins/ref/plugins
ls -lrt /usr/share/jenkins/ref/plugins
/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins/jenkins.war -p /usr/share/jenkins/ref/plugins -f "$3"