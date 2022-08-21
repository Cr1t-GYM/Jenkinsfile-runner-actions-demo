# How to copy the pipeline results to an external object storage

This example shows how to copy the pipeline results to an external object storage such as `AWS S3` by using
[artifact-manager-s3](https://plugins.jenkins.io/artifact-manager-s3/). In this example, it takes `AWS S3` as an example
and other object storage services should work as well.

If you use `AWS S3` like this example, you need to know your the region of the user, `AWS access key id`, `AWS secret access key`, 
`AWS S3 bucket name` and `AWS S3 bucket prefix` in advance. For example, if your `S3 URI` for a specific folder under a 
bucket is `s3://jenkins-action/test/`, `AWS S3 bucket name` is `jenkins-action` and `AWS S3 bucket prefix` is `test/`.
`AWS access key id` and `AWS secret access key` can be downloaded when you create a new user for your account.
Furthermore, in order to make this AWS access key have the ability to manage your S3 storage,
you will need to grant it `AmazonS3FullAccess` in the IAM user permission page.

Here is the step-by-step example for `jfr-container-action`:
1. Firstly, you will need to create a plugin list file `plugins.txt` which includes `artifact-manager-s3`.
2. Follow the example of [jenkins-secrets](../jenkins-secrets) and create two secrets for `AWS access key id` and `AWS secret access key`, respectively.
In this example, `AWS_ACCESS_KEY_ID` corresponds to the `AWS access key id` and `AWS_SECRET_ACCESS_KEY` corresponds to the `AWS secret access key`.
Please note that the names of your environment variables must start with `JENKINS_` in `jfr-static-image-action`.
3. Create a JCasC file like the following configuration example. In this example, you need to replace the following fields:
    1. `aws:awsCredentials:region` - Your user region.
    2. `aws:s3:container` - Your `AWS S3 bucket name`.
    3. `aws:s3:prefix` - Your `AWS S3 bucket prefix`.
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
aws:
  awsCredentials:
    credentialsId: "aws_key"
    region: "us-east-2"
  s3:
    container: "jenkins-action"
    disableSessionToken: false
    prefix: "test/"
    useHttp: false
    usePathStyleUrl: false
    useTransferAcceleration: false
unclassified:
  artifactManager:
    artifactManagerFactories:
      - jclouds:
          provider: "s3"
```
4. Create the `Jenkinsfile` which uses the uploading/downloading functions provided by `artifact-manager-s3`.
You can check the documentations for [archiveArtifacts](https://www.jenkins.io/doc/pipeline/steps/core/#archiveartifacts-archive-the-artifacts),
[unarchive](https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#unarchive-copy-archived-artifacts-into-the-workspace),
[stash](https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash-stash-some-files-to-be-used-later-in-the-build) and 
[unstash](https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#unstash-restore-files-previously-stashed).
In this example, it only shows how to use `archiveArtifacts` for uploading your pipeline results.
It assumes there is a maven project in your workspace and `artifact-manager-s3` will help you upload the compiled targets to the `AWS S3` after
the pipeline builds the sources successfully.
```groovy
pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage('build') {
            steps {
                sh 'mvn clean install -B --no-transfer-progress'
            }
        }
    }
    post {
        success {
            archiveArtifacts 'target/*.jar'
        }
    }
}
```
5. In your workflow definition, you will need to set up your credentials and `jfr-container-action` correctly.
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
