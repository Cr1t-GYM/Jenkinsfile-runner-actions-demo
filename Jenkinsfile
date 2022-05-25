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
    }
    post {
        always {
            step([$class: 'Mailer', notifyEveryUnstableBuild: true,
                recipients: '277645526@qq.com'])
        }
    }
}