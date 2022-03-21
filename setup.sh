#!/usr/bin/env bash

set -e

run() {
  echo "Deleting old binary files"
  rm -rf /usr/share/jenkins/ref/plugins
  rm -rf /app/jenkins

  echo "Exploding /app/jenkins-${JENKINS_VERSION}.war to /app/jenkins-${JENKINS_VERSION}"
  unzip /app/jenkins-${JENKINS_VERSION}.war -d /app/jenkins-${JENKINS_VERSION}
}

run "${1}" "${2}"