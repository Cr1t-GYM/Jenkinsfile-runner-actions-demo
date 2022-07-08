pipeline {
    agent none
    stages {
        stage('build on GitHub Actions runner') {
            agent any
            tools {
                maven 'maven'
            }
            steps {
                sh 'mvn clean install -B --no-transfer-progress'
            }
        }
        stage('build on AWS Server') {
            agent {
                label 'agent1'
            }
            tools {
                maven 'maven'
            }
            steps {
                sh 'git clone -b master https://github.com/Cr1t-GYM/Jenkinsfile-runner-actions-demo'
                sh 'mvn clean install -B --no-transfer-progress'
            }
        }
    }
}