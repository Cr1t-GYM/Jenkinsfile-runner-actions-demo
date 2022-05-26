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
                sh 'mvn clean install'
            }
        }
        stage('test casc env') {
            steps {
                echo "JCasC env.PP: ${env.PP}"
            }
        }
    }
}