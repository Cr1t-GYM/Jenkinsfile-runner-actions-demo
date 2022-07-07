pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        dir("${GITHUB_WORKSPACE}") {
            stage('env') {
                steps {
                    sh 'mvn --version'
                }
            }
            stage('build') {
                steps {
                    sh 'mvn clean install -B --no-transfer-progress'
                }
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