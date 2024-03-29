# Demo project for Jenkinsfile Runner Action for GitHub Actions in GSoC 2022

This is the demo project for the original [POC project](https://github.com/Cr1t-GYM/jenkins-action-poc). 
It teaches the users how to use Jenkinsfile-runner Actions.

## Demo
All the demos are stored in the `./demo` directory. You can use them with `jenkinsfile-runner-action`, `jfr-container-action` and `jfr-static-image-action`.
1. [Java demo](./demo/java): It's a Spring Boot project. The source files are generated by [Spring Initializr](https://start.spring.io/).
2. [JavaScript demo](./demo/javascript/my-react-app): It's a React project. You can generate it by using `npm init react-app ./my-react-app` in the command line.
3. [Scala demo](./demo/scala/scalaexample): It's a Scala project. You can generate it by using `sbt new scala/scalatest-example.g8` in the command line.
4. [Jenkins secrets demo](./demo/jenkins-secrets): It teaches you how to define and use secrets in the Jenkins pipeline.
5. [Jenkins environment variables demo](./demo/jenkins-envs): It teaches you how to define and use environment variables in the Jenkins pipeline.
6. [s3-artifact-manager demo](./demo/s3-artifact-manager): It teaches you how to store the pipeline results to an external storage.
7. [jobcacher demo](./demo/jobcacher): It teaches you how to cache the pipeline dependencies.
8. [remote agent demo](./demo/remote-agent): It teaches you how to trigger the building in the remote agents.

## How you can access Jenkinsfile-runner actions in your project?
Reference these actions in your workflow definition.
1. Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action@master
2. Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action@master
3. Cr1t-GYM/jenkins-action-poc/jenkins-setup@master
4. Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
5. Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master

## Step by step usage
1. Prepare a Jenkinsfile in your repository. You can check [the basic syntax of Jenkins pipeline definition](https://www.jenkins.io/doc/book/pipeline/syntax/).
2. Prepare a workflow definition under the `.github/workflows` directory. You can check [the official manual](https://docs.github.com/en/actions) for more details.
3. In your GitHub Action workflow definition, you need to follow these steps when calling other actions in sequence:
    1. Use a ubuntu runner for the job.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest   
   ```
    2. If you use jfr-container-action, you need to declare using the `ghcr.io/jenkinsci/jenkinsfile-runner:master` or any image extended it. If you use jfr-static-image-action, you can skip this step.
   ```Yaml
   jobs:
      job-name:
        runs-on: ubuntu-latest
        container:
          image: ghcr.io/jenkinsci/jenkinsfile-runner:master             
   ```   
    3. Call the `actions/checkout@v2` to pull your codes into the runner.
    4. If you use jfr-container-action, you need to call `Cr1t-GYM/jenkins-action-poc/jfr-container-action@master` and give necessary inputs. If you use jfr-static-image-action, you need to call `Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master` and give necessary inputs. See the [examples](#workflow-explanation) for these two actions.

## Workflow Explanation
You can find the workflow definition in the [.github/workflows/ci.yml](.github/workflows/ci.yml).
### jenkins-static-image-pipeline
This job pulls your repository first, and the workspace will be mapped to the container provided by 
`jfr-static-image-action`. By using the `Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master` and
passing the necessary inputs, you can start the pipeline. Please note that most of the GitHub Actions will become
invalid because of the isolation between the host machine and the container. You still can use `actions/checkout@v2`
to prepare your sources.
```yaml
  jenkins-static-image-pipeline:
     runs-on: ubuntu-latest
     name: jenkins-static-image-pipeline-test
     steps:
        - uses: actions/checkout@v2
        # jfr-static-image-action
        - name: Jenkins pipeline with the static image
          id: jenkins_pipeline_image
          uses:
             Cr1t-GYM/jenkins-action-poc/jfr-static-image-action@master
          with:
             command: run
             jenkinsfile: Jenkinsfile
             pluginstxt: plugins.txt
             jcasc: jcasc.yml
```
### jenkins-container-pipeline
This job pulls the `ghcr.io/jenkinsci/jenkinsfile-runner:master`, pulls your repository, setup maven and run the Jenkins pipeline finally.
Please note that the declaration of `ghcr.io/jenkinsci/jenkinsfile-runner:master` is necessary to use the `jfr-container-action` action.
By using the `Cr1t-GYM/jenkins-action-poc/jfr-container-action@master` and
passing the necessary inputs, you can start the pipeline.
```yaml
  jenkins-container-pipeline:
     runs-on: ubuntu-latest
     name: jenkins-prebuilt-container-test
     container:
        # prerequisite: extendance of ghcr.io/jenkinsci/jenkinsfile-runner:master
        image: path/to/your_own_image
     steps:
        - uses: actions/checkout@v2
        # jfr-container-action
        - name: Jenkins pipeline in the container
          id: jenkins_pipeline_container
          uses:
             Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
          with:
             command: run
             jenkinsfile: Jenkinsfile
             pluginstxt: plugins.txt
             jcasc: jcasc.yml
```
### jenkins-runtime-pipeline
This case is realized by the combination of jenkins-setup, jenkins-plugin-installation-action and jenkinsfile-runner-action. 
It will download all the dependencies and run the pipeline at the host machine directly. 
Its advantage is that it can support Linux, macOS and Windows runners. 
Its main disadvantage is the possibility of suffering from a plugins.jenkins.io outage.
```yaml
  jenkins-runtime-pipeline:
     # Run all the actions in the on demand VM.
     needs: syntax-check
     strategy:
        matrix:
           os: [ubuntu-latest, macOS-latest, windows-latest]
     runs-on: ${{ matrix.os }}
     name: jenkins-runtime-pipeline-test
     steps:
        - uses: actions/checkout@v2
        - name : Setup Jenkins
          uses: Cr1t-GYM/jenkins-action-poc/jenkins-setup
        - name: Jenkins plugins download
          id: jenkins_plugins_download
          uses: Cr1t-GYM/jenkins-action-poc/jenkins-plugin-installation-action
          with:
             pluginstxt: jenkins-setup/plugins.txt
        - name: Run Jenkins pipeline
          id: run_jenkins_pipeline
          uses: Cr1t-GYM/jenkins-action-poc/jenkinsfile-runner-action
          with:
             command: run
             jenkinsfile: Jenkinsfile
             jcasc: jcasc.yml
```
