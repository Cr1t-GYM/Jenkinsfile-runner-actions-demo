pipeline {
    agent any
    stages {
        stage('mvn env') {
            steps {
                sh 'mvn --version'
            }
        }
        stage('java env') {
            steps {
                sh 'java -version'
            }
        }
        stage('build') {
            steps {
                sh 'mvn clean install -e'
            }
        }
        stage('test terraform casc') {
            steps {
                sh 'ls /terraform-0.11'
                sh 'terraform --version'
            }
        }
    }
}