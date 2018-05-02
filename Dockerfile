FROM amazonlinux:2

# Java and maven are required for OASIS build (to build scala lambdas).
RUN yum install -y \
  git \
  tar \
  jq \
  docker \
  python-pip \
  awscli \
  go \
  zip \
  java-1.8.0-openjdk-devel \
  maven \
  && /usr/sbin/alternatives --auto java \
  && /usr/sbin/alternatives --auto javac \
  && yum remove -y java-1.7.0-openjdk \
  && yum clean all
RUN pip install docker-compose dumb-init

# Installs node / npm and grunt. Also required for OASIS build (for grunt).
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash \
  && . ~/.nvm/nvm.sh \
  && nvm install --lts \
  && npm install -g grunt-cli

COPY scripts/check-dockerhub.sh /usr/local/bin/
COPY scripts/get-latest-nonmerge-commit.sh /usr/local/bin/
COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
