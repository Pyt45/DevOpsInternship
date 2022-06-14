#!/bin/sh

echo "docker-compose, docker must be installed"

token="GR1348941nLvF6NkRuDVRx7oaRW8i"

sudo docker-compose up -d

sudo docker-compose exec gitlab-runner-container \
    gitlab-runner register --non-interactive --url https://gitlab.com/ \
    --registration-token $token --executor docker --description "Sample Runner 1" \
    --docker-image "docker:stable" --tag-list "test, pyt" --docker-volumes /var/run/docker.sock:/var/run/docker.sock

sudo docker-compose exec gitlab-runner-container gitlab-runner verify