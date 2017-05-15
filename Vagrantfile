# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.



Vagrant.configure("2") do |config|
  
  # default provision command
  config.vm.provision "shell", path: "common.sh", env: {"AWS_ACCESS_KEY_ID" => ENV["AWS_ACCESS_KEY_ID"], "AWS_SECRET_ACCESS_KEY" => ENV["AWS_SECRET_ACCESS_KEY", "AWS_DEFAULT_REGION" => ENV["AWS_DEFAULT_REGION"]]}
  
  # if you want to add aws ecr to your docker aws registry, please comment out default provision command and uncomment next line: 
  # config.vm.provision "shell", path: "common.sh", args: "--enable-aws-ecr", env: {"AWS_ACCESS_KEY_ID" => ENV["AWS_ACCESS_KEY_ID"], "AWS_SECRET_ACCESS_KEY" => ENV["AWS_SECRET_ACCESS_KEY", "AWS_DEFAULT_REGION" => ENV["AWS_DEFAULT_REGION"]]}
  config.vm.define "kube-master" do |master|
    master.vm.box = "ubuntu/xenial64"
    master.vm.box_check_update = false
    # master.vm.network "forwarded_port", guest: 8080, host: 8080
    master.vm.network "forwarded_port", guest: 6443, host: 6443
    master.vm.network "forwarded_port", guest: 8001, host: 8001
    master.vm.network "forwarded_port", guest: 9090, host: 9090
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
    node.vm.network "private_network", ip: "11.22.33.45"
    node.vm.provision "shell", path: "script-node.sh"
    node.vm.hostname = "node"
  end
  config.vm.define "kube-node-2" do |node|
    node.vm.box = "ubuntu/xenial64"
    node.vm.box_check_update = false
    node.vm.network "public_network"
    node.vm.network "private_network", ip: "11.22.33.46"
    node.vm.provision "shell", path: "script-node.sh"
    node.vm.hostname = "node-2"
  end
end
