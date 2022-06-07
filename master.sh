#!/usr/bin/env sh

# set -euxo pipefail
sudo hostnamectl set-hostname --static master
MASTER_IP="192.168.42.110"
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

sudo systemctl enable firewalld --now
sudo systemctl start firewalld

sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10252/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp
sudo firewall-cmd --reload
sudo modprobe overlay
sudo modprobe br_netfilter
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sh -c "sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"

sudo sh -c 'sudo cat <<EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
'

sudo systemctl daemon-reload

sudo systemctl restart docker

sudo kubeadm config images pull

sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --apiserver-cert-extra-sans=$MASTER_IP --pod-network-cidr=$POD_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap
# config_path="/vagrant/configs"

# if [ -d $config_path ]; then
#     rm -rf $config_path
# else
# mkdir -p $config_path
# fi

sudo cp -i /etc/kubernetes/admin.conf /vagrant/config
touch /vagrant/join.sh
chmod +x /vagrant/join.sh




sudo kubeadm token create --print-join-command > /vagrant/join.sh

sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF
# export kubever=$(kubectl version --output=json | base64 | tr -d '\n')
# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
# sleep 10

# echo "hello from master node" > test.txt
# sudo cp test.txt /vagrant/test.txt