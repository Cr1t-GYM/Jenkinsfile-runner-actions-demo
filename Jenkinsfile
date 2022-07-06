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
//                 sh 'mvn clean install -e'
                cache(maxCacheSize: 250, caches: [
                        [$class: 'ArbitraryFileCache', path: '/root/.m2', cacheValidityDecidingFile: 'pom.xml', compressionMethod: 'TARGZ']
                ]) {
                    sh 'mvn clean install -e'
                }
            }
        }
    }
}