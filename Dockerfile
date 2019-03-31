FROM jenkinsci/slave

USER root

ENV DOCKERVERSION=18.09.4
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

ENV DOCKERCOMPOSE_VERSION=1.24.0
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKERCOMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN groupadd -g 999 docker && usermod -aG docker jenkins

COPY mvn-settings.xml /home/jenkins/.m2/settings.xml
COPY ivy-settings.xml /home/jenkins/.ivy2/ivysettings.xml
RUN chown -R jenkins:jenkins /home/jenkins/.m2 /home/jenkins/.ivy2

USER jenkins
