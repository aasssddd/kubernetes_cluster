# Install Kubernetes cluster #
1. install virtualbox 
2. install vagrant
3. run
```bash
vagrant up
```
4. when vagrant attempt to start vm, it may ask you what network interface should use, please select the public facing network interface, in order to download kubernetes related package into vm.

## Join node ##
1. After vm environment are ready, login kube-master with command
```bash
vagrant ssh kube-master
```
2. get token by:
```bash
sudo kubeadm token list
```
3. copy token and exit current ssh session
4. login kube-node and execute join command
```bash
vagrant ssh kube-node
sudo kubeadm join --token=<token> 11.22.33.44:6443
```

## Manual Steps ##
1. edit /etc/kubernetes/manifest/kube-apiserver.yaml at master node with sudo
```bash
sudo nano /etc/kubernetes/manifest/kube-apiserver.yaml
```
replace --advertise-address and livenessProbe/httpGet/host to 11.22.33.44, and make sure --secure-port and /livenessProbe/httpGet/port are both 6443

2. add kube-dns to DNS nameservers, first find kube-dns service by:
```bash
kubectl -n kube-system describe service kube-dns
```
then you should get name server's IP address, in my environment is 10.96.0.10
```language
Name:           kube-dns
Namespace:      kube-system
Labels:         k8s-app=kube-dns
            kubernetes.io/cluster-service=true
            kubernetes.io/name=KubeDNS
Annotations:        <none>
Selector:       k8s-app=kube-dns
Type:           ClusterIP
IP:         10.96.0.10
Port:           dns 53/UDP
Endpoints:      10.244.0.9:53
Port:           dns-tcp 53/TCP
Endpoints:      10.244.0.9:53
Session Affinity:   None
Events:         <none>
```
edit /etc/resolv.conf and add namespace < dns - ip >
```bash
echo "nameserver 10.96.0.10" >> /etc/resolv.conf
```

## Verify installation ##
1. login kube-master and all nodes are ready
```bash
vagrant ssh kube-master
kubectl get nodes # check if all nodes are ready
kubectl get pod --all-namespaces # check if all pod are running
```

2. deploy /tmp/resource/demo.yaml and /tmp/resource/demo-service.yaml by
```bash
vagrant ssh kube-master
kubectl apply -f /tmp/resource/demo.yaml
kubectl apply -f /tmp/resource/demo-service.yaml
```

3. get service
```bash
> kubectl describe service nginxservice
Name:           nginxservice
Namespace:      default
Labels:         name=nginxservice
Annotations:    kubectl.kubernetes.io/last-applied-configuration=...
Selector:       app=nginx
Type:           NodePort
IP:         10.100.172.146
Port:           http    80/TCP
NodePort:       http    31212/TCP
Endpoints:      10.244.1.38:80,10.244.2.9:80
Session Affinity:   None
Events:         <none>
```

4. hit the main page:
```bash
curl http://10.100.172.146
```

### Good Luck! ###


## Appendix ##

### Kubernetes Dashboard ###

```bash
vagrant ssh kube-master
kubectl apply -f /tmp/resource/dashboard.yaml
```

### Allow pull image from AWS ECR ###
First add AWS Credentials to ENV:
```language
export AWS_ACCESS_KEY_ID = your aws access key id
export AWS_SECRET_ACCESS_KEY = your aws secret access key
export AWS_DEFAULT_REGION = default region
```
Open Vagrantfile and comment out default provisioner, uncomment provisioner with args --enable-aws-ecr:
```language
# default provision command
# config.vm.provision "shell", path: "common.sh", env: {"AWS_ACCESS_KEY_ID" => ENV["AWS_ACCESS_KEY_ID"], "AWS_SECRET_ACCESS_KEY" => ENV["AWS_SECRET_ACCESS_KEY", "AWS_DEFAULT_REGION" => ENV["AWS_DEFAULT_REGION"]]}
  
# if you want to add aws ecr to your docker aws registry, please comment out default provision command and uncomment next line: 
config.vm.provision "shell", path: "common.sh", args: "--enable-aws-ecr", env: {"AWS_ACCESS_KEY_ID" => ENV["AWS_ACCESS_KEY_ID"], "AWS_SECRET_ACCESS_KEY" => ENV["AWS_SECRET_ACCESS_KEY", "AWS_DEFAULT_REGION" => ENV["AWS_DEFAULT_REGION"]]}
...
...
```

### More Node ###

1. edit Vagrantfile to add VM section, bootstrap node with
```bash
vagrant up new_node_name
```
2. join current kubernetes cluster
```bash
vagrant ssh new_node_name
sudo kubeadm join --token=<token> 11.22.33.44:6443
```

## Shutdown & Restart ##
After kubernetes cluster environment has bootstrapped, you can shutdown with
```bash
vagrant halt
```
And start with
```bash
vagrant up --no-provision #with --no-provision parameter to avoid run bootstrap command again
```
Also, reload with
```bash
vagrant reload --no-provision
```
