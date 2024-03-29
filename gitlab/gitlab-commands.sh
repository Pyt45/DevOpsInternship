#!/usr/bin/env sh

sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
sudo chmod +x /usr/local/bin/gitlab-runner
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
sudo /usr/local/bin/gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo /usr/local/bin/gitlab-runner start

kubectl create namespace gitlab
sudo firewall-cmd --permanent --add-port=53/tcp
kubectl apply -f gitlab-account.yml
kubectl apply -f gitlab-secret.yml

mkdir -p $HOME/centos/k8s
touch $HOME/centos/k8s/ca.crt

kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 -d > /home/vagrant/centos/k8s/ca.crt

token=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='gitlab-admin')].data.token}" | base64 -d)
sudo /usr/local/bin/gitlab-runner register \
  --non-interactive --url "https://gitlab.com/" --registration-token "GITLAB_CI_TOKEN" \
  --executor "kubernetes" --description "kubernetes-runner" --tag-list "k8s-runner, koby, test, java, python" \
  --kubernetes-host "https://192.168.42.110:6443" --kubernetes-ca-file "$HOME/centos/k8s/ca.crt" --kubernetes-bearer_token "$token"

dns = ["172.65.251.78"]
dns_search = ["https://gitlab.com"]
service_account = "gitlab-admin"