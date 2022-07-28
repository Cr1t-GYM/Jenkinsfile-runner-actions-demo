pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage('check jenkins core version') {
            steps {
                sh 'java -jar /app/jenkins/jenkins.war --version'
            }
        }
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