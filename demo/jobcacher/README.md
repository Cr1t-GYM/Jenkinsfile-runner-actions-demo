# How to cache the pipeline data

This example shows how to cache the pipeline data by using the [jobcacher plugin](https://plugins.jenkins.io/jobcacher/).
In this example, it takes `AWS S3` as an example and other compatible object storage services should work as well.

If you use `AWS S3` like this example, you need to know your the region of the user, `AWS access key id`, 
`AWS secret access key` and `AWS S3 bucket name`. The descriptions about these prerequisites are explained in
[s3-artifact-manager example](../s3-artifact-manager) in detailed.

Here is the step-by-step example for the `jfr-container-action`:
1. Firstly, you need to create a plugin list file `plugins.txt` which includes `jobcacher`.
2. Follow the example of the [jenkins-secrets](../jenkins-secrets) and create two separate secrets for `AWS access key id` and `AWS secret access key`.
   In this example, `AWS_ACCESS_KEY_ID` corresponds to the `AWS access key id` and `AWS_SECRET_ACCESS_KEY` corresponds to the `AWS secret access key`.
   Please note that the names of your environment variables must start with `JENKINS_` in `jfr-static-image-action`.
3. Create a JCasC file like the following configuration example. In this example, you will need to replace the following fields:
    1. `unclassified:globalItemStorage:storage:s3:region` - Your user region.
    2. `unclassified:globalItemStorage:storage:s3:bucketName` - Your `AWS S3 bucket name`.
```yaml
credentials:
  system:
    domainCredentials:
      - credentials:
          - aws:
              accessKey: "${AWS_ACCESS_KEY_ID}"
              description: "aws access key for yourself"
              id: "aws_key"
              scope: GLOBAL
              secretKey: "${AWS_SECRET_ACCESS_KEY}"
unclassified:
  globalItemStorage:
    storage:
      s3:
        bucketName: "jenkins-action"
        credentialsId: "aws_key"
        region: "us-east-2"
```
4. Create the `Jenkinsfile` which uses cache functions provided by the `jobcacher`.
You can check [the documentations of cache function](https://www.jenkins.io/doc/pipeline/steps/jobcacher/#cache-caches-files-from-previous-build-to-current-build). 
It assumes that there is a maven project in your workspace, and the plugin will cache the dependencies as specified ih the `pom.xml` file.
The `pom.xml` file will be used to determine whether the cache is up-to-date or not. 
Only up-to-date caches will be restored and only outdated caches will be created.
```groovy
pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage('build') {
            steps {
                cache(maxCacheSize: 250, caches: [
                        [$class: 'ArbitraryFileCache', path: '/root/.m2', cacheValidityDecidingFile: 'pom.xml', compressionMethod: 'TARGZ']
                ]) {
                    sh 'mvn clean install -e'
                }
            }
        }
    }
}
```
5. In your workflow definition, you need to set up your credentials and `jfr-container-action` correctly.
```yaml
      - name: Jenkins pipeline in the container
        id: jenkins_pipeline_container
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml
```
