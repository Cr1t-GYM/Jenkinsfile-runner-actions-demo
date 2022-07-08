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
                sh 'mvn clean install -B --no-transfer-progress'
            }
        }
    }
}