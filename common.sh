# common.sh
sudo su -
apt-get update && apt-get install -y apt-transport-https wget
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
# apt-get -y install \
#     linux-image-extra-$(uname -r) \
#     linux-image-extra-virtual

apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    traceroute \
    iftop

sudo wget -qO- https://get.docker.com/ | sh

# apt-get install -y docker-ce


# Install docker if you don't have it already.
apt-get install -y docker-engine
apt-get install -y kubelet kubeadm kubectl kubernetes-cni

# disable firewall
sudo ufw disable