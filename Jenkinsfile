pipeline {
    agent any
    stages {
        stage('build') {
            agent {
                docker {
                    label 'docker'
                    image 'maven:3.6.3-jdk-8-openj9'
                }
            }
            steps {
                sh 'mvn --version'
            }
        }
    }
}