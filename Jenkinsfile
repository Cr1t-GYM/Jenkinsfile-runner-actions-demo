pipeline {
    agent any
    stages {
        stage('env') {
            steps {
                sh 'mvn --version'
            }
        }
        stage('build') {
            steps {
                sh 'mvn clean install -e'
            }
        }
    }
}