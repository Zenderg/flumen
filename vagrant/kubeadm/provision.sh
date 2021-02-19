sudo swapoff -a

K8S_VERSION="v1.20.1"

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

systemctl enable --now kubelet

kubeadm init \
  --control-plane-endpoint="$(cat /etc/hostname)" \
  --pod-network-cidr="192.168.0.0/16" || exit 1

mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

kubectl apply -f https://docs.projectcalico.org/v3.17/manifests/calico.yaml

kubectl taint nodes --all node-role.kubernetes.io/master-
