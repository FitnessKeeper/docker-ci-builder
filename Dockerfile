FROM amazonlinux:2

RUN yum install -y git
RUN yum install -y jq
RUN yum install -y docker
RUN yum install -y python-pip
RUN pip install docker-compose
RUN yum install -y awscli

COPY check-dockerhub.sh /usr/local/bin/
COPY get-latest-nonmerge-commit.sh /usr/local/bin/
