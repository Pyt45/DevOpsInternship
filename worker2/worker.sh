#!/bin/sh

sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

sudo sh -c 'sudo cat <<EOF > /etc/hosts
192.168.42.110 master
192.168.42.111 worker1
192.168.42.112 worker2
'
sudo setenforce 0
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

sudo yum install -y yum-utils

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl enable docker --now
sudo systemctl start docker

sudo sh -c 'sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'
sudo yum install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet --now
sudo systemctl start kubelet

sudo systemctl stop firewalld

sudo kubeadm join 192.168.42.110:6443 --token otr77t.j93anao7ip96bo4c --discovery-token-ca-cert-hash sha256:25341255d00808fb8e47982f10c02504eb489e080a3cb9ebc48c5b92e47ede8a