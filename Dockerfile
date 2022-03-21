FROM jenkins/jenkinsfile-runner:adoptopenjdk-8-hotspot

ENV JENKINS_VERSION=2.338

COPY plugins.txt /app/setup/plugins.txt

RUN curl -L http://updates.jenkins.io/download/war/${JENKINS_VERSION}/jenkins.war -o /app/jenkins-${JENKINS_VERSION}.war
RUN apt-get update && apt-get install -y zip git

COPY setup.sh /app/setup/setup.sh
RUN /app/setup/setup.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh" ]
