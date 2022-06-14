#!/usr/bin/env sh

sudo yum install -y git

git clone https://github.com/haoshuwei/gitlab-runner.git

cd gitlab-runner
sed -i 's/gitlabUrl: /gitlabUrl: https://gitlab.com/' values.yml
sed -i 's/runnerRegistrationToken: /runnerRegistrationToken: token' values.yml