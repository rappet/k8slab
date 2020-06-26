#!/usr/bin/env bash

set -e # exit on non zero return status
set -v # Print shell input lines as they are read.

# Load br_netfilter
modprobe br_netfilter
cp /vagrant/modules.load.d/bridge.conf /etc/modules-load.d/bridge.conf

echo "Installing k8s network bridge sysctls"
cp /vagrant/sysctl.conf.d/k8s.conf /etc/sysctl.d/k8s.conf
sysctl --system

echo "Install apt https protocol"
apt-get update
apt-get install -y apt-transport-https curl

# Setup apt repositories
CRIO_VERSION=1.17
. /etc/os-release
sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${NAME}_${VERSION_ID}/ /' >/etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${NAME}_${VERSION_ID}/Release.key -O- | sudo apt-key add -

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update -qq

echo "Install CRI-O"
apt-get install -y cri-o-${CRIO_VERSION}

echo "Install kubelet, kubeadm, kubectl"
apt-get install -y kubelet kubeadm kubectl

echo "Copy kubelet config"
cp /vagrant/kubelet/config.yaml /var/lib/kubelet/config.yaml

systemctl daemon-reload
systemctl restart kubelet