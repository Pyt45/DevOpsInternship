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

# sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sudo firewall-cmd --permanent --add-port=6783/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp
sudo firewall-cmd --permanent --add-port=30000-32767/tcp
sudo firewall-cmd --reload
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sh -c "sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
sudo swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab
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

# sudo mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# sudo kubeadm join 192.168.42.110:6443 --token a881u7.4rmznjwdwikz5spn --discovery-token-ca-cert-hash sha256:aec2b927e97b5850d49b04a5b995f7454e37596e213c0affacfce83561dea912