pipeline {
    agent {
        docker {
            image 'maven:3.6.3-jdk-8-openj9'
        }
    }
    stages {
        stage('env') {
            steps {
                sh 'mvn --version'
            }
        }
        state('build') {
            steps {
                sh 'mvn clean install'
            }
        }
    }
}