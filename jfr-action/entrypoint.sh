#!/usr/bin/env bash

set -e

java -jar /app/bin/jenkins-plugin-manager.jar "$1" -w /app/jenkins/jenkins.war -p "$2" -f "$3"