FROM amazonlinux:2

RUN yum install -y git jq docker python-pip awscli go zip
RUN pip install docker-compose dumb-init

COPY scripts/check-dockerhub.sh /usr/local/bin/
COPY scripts/get-latest-nonmerge-commit.sh /usr/local/bin/
COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
