pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage('check jenkins core version') {
            steps {
                script {
                    def proc = '/usr/local/opt/openjdk@11/bin/java -jar /app/jenkins/jenkins.war --version'.execute()
                    def sout = new StringBuilder(), serr = new StringBuilder()
                    proc.consumeProcessOutput(sout, serr)
                    proc.waitForOrKill(1000)
                    println "out> $sout\nerr> $serr"
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