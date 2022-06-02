#!/bin/sh

sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

sudo sh -c 'sudo cat <<EOF > /etc/hosts
192.168.42.110 master
192.168.42.111 worker1
192.168.42.112 worker2
'
sudo setenforce 0

sudo systemctl enable firewalld --now
sudo systemctl start firewalld

sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10252/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp
sudo firewall-cmd --reload
sudo modprobe br_netfilter
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sh -c "sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"

sudo swapoff -a && sudo sed -i '/ swap / s/^/#/' /etc/fstab

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
sudo yum install -y iproute-tc
# sudo systemctl stop firewalld

sudo rm -rf /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export kubever=$(kubectl version | base64 | tr -d '\n')
sudo kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

# sudo kubeadm join 192.168.42.110:6443 --token g4nk52.bsyfq5d2n6mij9l9 --discovery-token-ca-cert-hash sha256:6bc7311ab80db08ad8a58d3b4bf92059d7913b83abdf1160e9b163e732bc2190
# sudo kubeadm join 192.168.42.110:6443 --token ckr8ax.4d9dbr4t8fgvsn5d --discovery-token-ca-cert-hash sha256:bd110046e5c174ae58eea4e0f66fd12c82769b82d7cb9ca2af331075c4246a0f