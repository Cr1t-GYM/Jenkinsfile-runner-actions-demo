#!/usr/bin/env bash

set -e

java -jar /app/bin/jenkins-plugin-manager.jar --war /app/jenkins/jenkins.war --plugin-file "$2"

/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins/jenkins.war -p "$2" -f "$3"