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
        stage('test casc env') {
            steps {
                echo "An environment variable configured via JCasC: ${env.SOME_CASC_ENV_VAR}"
            }
        }
        stage('test terraform casc') {
            steps {
                terraformInstallation("terraform")
                sh 'ls /terraform-0.11'
                sh 'terraform --version'
            }
        }
    }
}