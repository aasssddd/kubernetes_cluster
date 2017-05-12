# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
 
  config.vm.provision "shell", path: "common.sh"
  config.vm.define "kube-master" do |master|
    master.vm.box = "ubuntu/xenial64"
    master.vm.box_check_update = false
    # master.vm.network "forwarded_port", guest: 8080, host: 8080
    master.vm.network "forwarded_port", guest: 6443, host: 6443
    master.vm.network "forwarded_port", guest: 8001, host: 8001
    master.vm.network "public_network"
    master.vm.network "private_network", ip: "11.22.33.44"
    master.vm.provision "shell", path: "script-master.sh"
    master.vm.hostname = "master"
    master.vm.synced_folder "resources/", "/tmp/resources"
  end
  config.vm.define "kube-node" do |node|
    node.vm.box = "ubuntu/xenial64"
    node.vm.box_check_update = false
    node.vm.network "public_network"
    node.vm.network "forwarded_port", guest: 8080, host: 8082
    node.vm.network "forwarded_port", guest: 9090, host: 9090
    node.vm.network "private_network", ip: "11.22.33.45"
    node.vm.provision "shell", path: "script-node.sh"
    node.vm.hostname = "node"
  end
end
