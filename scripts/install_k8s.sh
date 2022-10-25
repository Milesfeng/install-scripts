#!/bin/sh
set -e
#sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
#sudo swapoff -a
#sudo kubeadm reset -f
#sudo systemctl daemon-reload
#sudo systemctl restart kubelet


apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat >/etc/apt/sources.list.d/kubernetes.list <<-EOF
			deb https://apt.kubernetes.io/ kubernetes-xenial main
			EOF

apt-get update

apt-get install --allow-downgrades -y kubelet=1.19.16-00 kubeadm=1.19.16-00 kubectl=1.19.16-00
sudo apt-mark hold kubelet kubeadm kubectl

iptables -F
iptables -P FORWARD ACCEPT
iptables-save > /etc/sysconfig/iptables


cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
