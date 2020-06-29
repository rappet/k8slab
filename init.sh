# Init K8s
kubeadm init --config /vagrant/kubeadm.yaml
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

# Install Calico
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# Allow scheduling Pods on control-plane nodes
kubectl taint nodes --all node-role.kubernetes.io/master-

# Install kubernetes dashboard
kubectl apply -f /vagrant/dashboard/dashboard.yaml
kubectl apply -f /vagrant/dashboard/admin-user.yaml