FROM jenkins/agent
USER root

RUN apt-get update && apt-get install -y \
    python3 \
    curl \
 && rm -rf /var/lib/apt/lists/*

ENV DOCKERVERSION=27.1.1
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

ENV DOCKERCOMPOSE_VERSION=2.29.1
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKERCOMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN groupadd -g 999 docker && usermod -aG docker jenkins

COPY mvn-settings.xml /home/jenkins/.m2/settings.xml
COPY ivy-settings.xml /home/jenkins/.ivy2/ivysettings.xml
RUN chown -R jenkins:jenkins /home/jenkins/.m2 /home/jenkins/.ivy2

USER jenkins
