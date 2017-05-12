# Install Kubernetes cluster#
1. install virtualbox 
2. instal vagrant
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

## Verify installation ##
1. login kube-master and all nodes are ready
```bash
vagrant ssh kube-master
kubectl get nodes # check if all nodes are ready
kubectl get pod --all-namespaces # check if all pod are running
```

## More node ##
1. edit Vagrantfile to add VM section, bootstrap node with
```bash
vagrant up new_node_name
```
2. join current kubernetes cluster
```bash
vagrant ssh new_node_name
sudo kubeadm join <token> <api_server_host>:<api_server_port>
```