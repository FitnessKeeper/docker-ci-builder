FROM amazonlinux:2

RUN yum install -y git
RUN yum install -y jq
RUN yum install -y docker

COPY check-dockerhub.sh /usr/local/bin/
COPY get-latest-nonmerge-commit.sh /usr/local/bin/
