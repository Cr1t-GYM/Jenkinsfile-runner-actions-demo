# extend vannila image
FROM jenkins/jenkinsfile-runner
# prepare env
ENV JENKINS_VERSION=2.319.3
RUN curl -L http://updates.jenkins.io/download/war/${JENKINS_VERSION}/jenkins.war -o /app/jenkins-${JENKINS_VERSION}.war
COPY entrypoint.sh /entrypoint.sh
#RUN cd /app/jenkins && jar -cvf jenkins.war *
# extra env
RUN apt-get update && apt-get install -y zip git maven

ENTRYPOINT ["/entrypoint.sh"]