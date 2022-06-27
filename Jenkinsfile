pipeline {
    agent any
    tools {
        maven 'maven'
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
        stage('find maven repo') {
            steps {
                sh 'echo $MAVEN_HOME && ls -al ~/.m2'
            }
        }
    }
}