# script-master.sh

sudo kubeadm init --apiserver-advertise-address "11.22.33.44" --pod-network-cidr 10.244.0.0/16
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

# kubectl taint nodes --all node-role.kubernetes.io/master-
# add flannel network
kubectl apply -f /tmp/resource/kube-flannel-rbac.yaml
kubectl apply -f /tmp/resource/flannel.yaml
# add dashboard ui, localhost:8001/ui
# kubectl create -f https://git.io/kube-dashboard