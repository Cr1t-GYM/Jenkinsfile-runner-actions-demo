pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage('check jenkins core version') {
            steps {
                script {
                    println 'Jenkins core version: ' + Jenkins.instance.getVersion()
                }
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