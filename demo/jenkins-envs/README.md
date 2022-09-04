# How to use environment variables in the Jenkins pipeline and JCasC

The idea is similar with how to use secrets except that you don't have to define them as secrets in the GitHub Secret page.

1. Take `JENKINS_HELLO=World` as an example. In your workflow definition, when you use `jfr-container-action`, `jfr-static-image-action` or `jfr-runtime-action`,
   you need to define `JENKINS_HELLO=World` as environment variable.
   Please note your customized environment variables must start with `JENKINS_` in `jfr-static-image-action`.
   Other actions don't have this naming constraint. The following workflow definition takes `jfr-static-image-action` as an example.
   ```yaml
      - name: Jenkins pipeline in the container
        id: jenkins_pipeline_container
        env:
          JENKINS_HELLO: World
        uses:
          jenkinsci/jfr-static-image-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml
   ```
2. Now your Jenkins execution environment has an environment variable called `JENKINS_HELLO`.
   You can refer it by using `${JENKINS_HELLO}` in the JCasC or Jenkins pipeline like the way of using secrets.
   