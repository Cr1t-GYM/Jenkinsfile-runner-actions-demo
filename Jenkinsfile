pipeline {
    agent none
    stages {
        stage('build on GitHub Actions runner') {
            agent any
            tools {
                maven 'maven'
            }
            steps {
                sh 'mvn clean install -B --no-transfer-progresse'
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
                git branch: 'master', url: 'https://github.com/Cr1t-GYM/Jenkinsfile-runner-actions-demo'
                sh 'mvn clean install -B --no-transfer-progress'
            }
        }
    }
}