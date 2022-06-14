#!/bin/sh

sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
sudo chmod +x /usr/local/bin/gitlab-runner
# sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
# sudo /usr/local/bin/gitlab-runner install --user=gitlab-runner --working-directory=$HOME/gitlab-runner
sudo /usr/local/bin/gitlab-runner register --non-interactive -u https://gitlab.com -r GR1348941nLvF6NkRuDVRx7oaRW8i --executor docker --docker-image busybox:latest --tag-list "test, pyt" 
# --docker-network-mode "host"
sudo /usr/local/bin/gitlab-runner verify
# sudo /usr/local/bin/gitlab-runner unregister --all-runners
TOKEN=$(sudo cat /etc/gitlab-runner/config.toml | grep token | cut -d "=" -f2 | tr -d "\" ")
# ntSNUfky-jQRGyE5sGLn