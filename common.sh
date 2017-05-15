# common.sh
sudo su -
apt-get update && apt-get install -y apt-transport-https wget
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get -y install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

apt-get -y install \
   apt-transport-https \
   ca-certificates \
   curl \
   software-properties-common \
   traceroute \
   iftop

sudo wget -qO- https://get.docker.com/ | sh

# Install docker if you don't have it already.
apt-get install -y docker-engine
apt-get install -y kubelet kubeadm kubectl kubernetes-cni

if [[ $1 == "--enable-aws-ecr" ]]; then
	
#statements
apt-get install -y awscli golang git make
# add AWS credential to environment variable
mkdir ~/.aws
touch ~/.aws/credentials
cat <<EOF > $HOME/.aws/credentials
[default]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
EOF

touch ~/.aws/config
cat <<EOF > $HOME/.aws/config
[default]
region=$AWS_DEFAULT_REGION
EOF
chmod 600 ~/.aws/config

# clone into local
git clone https://github.com/awslabs/amazon-ecr-credential-helper.git ~/source/src/github.com/awslabs/amazon-ecr-credential-helper

# set GOPATH
export GOPATH=~/source

# make bin 
cd ~/source/src/github.com/awslabs/amazon-ecr-credential-helper
make

# copy to /usr/local/bin
sudo cp ~/source/src/github.com/awslabs/amazon-ecr-credential-helper/bin/docker-credential-ecr-login /usr/local/bin/

# create ~/.docker/config.json
mkdir ~/.docker
cat <<EOF > $HOME/.docker/config.json
{
	"credsStore": "ecr-login"
}
EOF

fi


# disable firewall
sudo ufw disable
