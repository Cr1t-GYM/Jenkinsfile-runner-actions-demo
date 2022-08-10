# How to use secrets safely in the Jenkins pipeline and JCasC

Basically, the idea is defining the pipeline secrets in the GitHub Actions Secrets, 
and map them as environment variables in the workflow definition.
Therefore, Jenkins pipeline and JCasC can read them as environment variables.
Here is the step-by-step example.

1. Firstly, you need to create the secrets you need in the Settings -> Secrets -> Action,
   which is in the GitHub repository page.
   For example, I create a secret called `AWS_KEY`.
2. In your workflow definition, when you use `jfr-container-action`, `jfr-static-image-action` or `jenkinsfile-runner-action`,
   you need to map `AWS_KEY` as environment variable by using `${{ secrets.AWS_KEY }}`.
   Please note your customized environment variables must start with `JENKINS_` in `jfr-static-image-action`.
   Other actions don't have this naming constraint. The following workflow definition takes `jfr-container-action` as an example.
```yaml
      - name: Jenkins pipeline in the container
        id: jenkins_pipeline_container
        env:
          AWS_KEY: ${{ secrets.AWS_KEY }}
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml
```
3. Now your Jenkins execution environment has an environment variable called `AWS_KEY`.
    1. If you want to refer `AWS_KEY` in the JCasC, you can refer it as `${AWS_KEY}` like the following example.
   ```yaml
      credentials:
         system:
            domainCredentials:
               - credentials:
                    - aws:
                         accessKey: "your-access-key"
                         description: "aws access key for yourself"
                         id: "aws_key"
                         scope: GLOBAL
                         secretKey: "${AWS_KEY}"
   ```
   2. If you want to refer `AWS_KEY` in the Jenkinsfile, you can refer it as `${AWS_KEY}` in the pipeline.
   ```groovy
      pipeline {
          echo "${AWS_KEY}"
      }
   ```
