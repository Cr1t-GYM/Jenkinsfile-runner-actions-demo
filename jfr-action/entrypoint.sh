#!/usr/bin/env bash

set -e

ls /github/workspace/

/app/bin/jenkinsfile-runner-launcher "$1" -w /app/jenkins/jenkins.war -p "$2" -f "$3"