FROM docker:stable

RUN apk add --update git
RUN apk add --update jq
RUN apk add --update curl

COPY check-dockerhub.sh /usr/local/bin/
COPY get-latest-nonmerge-commit.sh /usr/local/bin/