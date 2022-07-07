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
    }
    post {
        always {
            dir("/") {
                archiveArtifacts 'jenkinsHome/jobs/job/builds/*'
            }
        }
        success {
            dir("${GITHUB_WORKSPACE}") {
                archiveArtifacts 'target/*.jar'
            }
        }
    }
}