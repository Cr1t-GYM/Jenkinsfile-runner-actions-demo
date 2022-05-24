# extend vannila image
FROM jenkins/jenkinsfile-runner
# prepare env
RUN cd /app/jenkins && jar -cvf jenkins.war *
# extra env
RUN apt-get update && apt-get install -y zip git maven

ENTRYPOINT ["/entrypoint.sh"]