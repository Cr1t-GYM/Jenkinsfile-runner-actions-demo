# How to trigger the building in the remote agents

This example shows how to trigger the building in other remote agents by using [ssh-slaves](https://plugins.jenkins.io/ssh-slaves/).
You might need a running server provided by cloud providers such as AWS.
In this example, it takes `AWS EC2` as an example and other similar services should work as well.

Here is the step-by-step example in `jfr-container-action`.
1. Firstly, follow the instructions about [generating the SSH key pair](https://www.jenkins.io/doc/book/using/using-agents/#generating-an-ssh-key-pair).
2. Follow the example of [jenkins-secrets](../jenkins-secrets) and create two secrets for the public IPv4 address of host machine, and the SSH private key generated in the first step.
   In this example, `AWS_SSH_HOST` corresponds to the public IPv4 address of host machine,
   and `AWS_SSH_PKEY` corresponds to the SSH private key.
3. Follow the instructions about [creating your Docker agent](https://www.jenkins.io/doc/book/using/using-agents/#creating-your-docker-agent). 
   As your host machine might already have a ssh server running on the 22 port, you should use another port for the docker command, such as -p 4444:22. 
   In this example, it uses -p 4444:22 for port mapping. 
   If you create the machines in cloud providers such as AWS, you need to create the correct inbound rule for the port 4444.
   For Example, if you use port 4444 for network redirection, you need to create the TCP protocol for port 4444 and allow the network from any ip ranges.
4. Create a JCasC file like the following configuration example.
```yaml
credentials:
  system:
    domainCredentials:
      - credentials:
          - basicSSHUserPrivateKey:
              description: "jenkins aws server key"
              id: "jenkins_aws_us_east_2"
              privateKeySource:
                directEntry:
                  privateKey: "${AWS_SSH_PKEY}"
              scope: GLOBAL
              username: "jenkins"
jenkins:
  nodes:
    - permanent:
        labelString: "agent1"
        launcher:
          ssh:
            credentialsId: "jenkins_aws_us_east_2"
            host: "${AWS_SSH_HOST}"
            javaPath: "/opt/java/openjdk/bin/java"
            port: 4444
            sshHostKeyVerificationStrategy:
              manuallyTrustedKeyVerificationStrategy:
                requireInitialManualTrust: false
        mode: EXCLUSIVE
        name: "agent1"
        nodeDescription: "jenkinsfile-runner action tests"
        nodeProperties:
          - envVars:
              env:
                - key: "JAVA_HOME"
                  value: "/opt/java/openjdk"
        remoteFS: "/home/jenkins"
        retentionStrategy: "always"
```
4. Create the `Jenkinsfile` which uses the remote `agent1` declared in step3. 
   In this example, it assumes there is a maven project in your workspace.
```groovy
pipeline {
    agent none
    stages {
        stage('Build on GitHub Actions runner') {
            agent any
            tools {
                maven 'maven'
            }
            steps {
                sh 'mvn clean install -B --no-transfer-progress'
            }
        }
        stage('Build on AWS Server') {
            agent {
                label 'agent1'
            }
            tools {
                maven 'maven'
            }
            steps {
                sh 'mvn clean install -B --no-transfer-progress'
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
          AWS_SSH_PKEY: ${{ secrets.AWS_SSH_PKEY }}
          AWS_SSH_HOST: ${{ secrets.AWS_SSH_HOST }}
        uses:
          Cr1t-GYM/jenkins-action-poc/jfr-container-action@master
        with:
          command: run
          jenkinsfile: Jenkinsfile
          pluginstxt: plugins.txt
          jcasc: jcasc.yml
```
