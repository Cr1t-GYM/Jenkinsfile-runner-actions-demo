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
        post {
            always {
                emailext body: 'A Test EMail', subject: 'Test'
            }
        }
    }
}