#!/bin/sh

if [[ "$1" = "-d" || "$1" = "--debug" ]] ; then
  DEBUG=true
fi

if [[ ! $DOCKER_LOGIN ]] ; then
  echo "need to set DOCKER_LOGIN env var" >&2
  exit 2
fi
if [[ ! $DOCKER_PASSWORD ]] ; then
  echo "need to set DOCKER_PASSWORD env var" >&2
  exit 2
fi
if [[ ! $DOCKER_REPO ]] ; then
  echo "need to set DOCKER_REPO env var" >&2
  exit 2
fi
if [[ ! $DOCKER_TAG ]] ; then
  echo "need to set DOCKER_TAG env var" >&2
  exit 2
fi

TOKEN=$( curl -sSLd "username=${DOCKER_LOGIN}&password=${DOCKER_PASSWORD}" https://hub.docker.com/v2/users/login | jq -r ".token" )
found=$(curl -s -I -H "Authorization: JWT $TOKEN" "https://hub.docker.com/v2/repositories/${DOCKER_REPO}/tags/${DOCKER_TAG}/" | grep 'HTTP/1.1 200 OK' > /dev/null; echo $?)
if [[ $found = 0 ]]; then
  echo $DOCKER_TAG
  exit 0
else
  [[ $DEBUG ]] && echo "${DOCKER_TAG} not found" >&2
  exit 0
fi
