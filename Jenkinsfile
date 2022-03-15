pipeline {
    agent {
        docker {
            image 'maven:3.6.3-jdk-8-openj9'
            args '-u root'
        }
    }
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