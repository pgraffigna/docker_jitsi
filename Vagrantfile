# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
    
  config.vm.define "master" do |m|
    m.vm.box = "geerlingguy/ubuntu1804"
    m.vm.network "private_network", ip: "192.168.60.10"
    m.vm.network "forwarded_port", guest: 8000, host: 8000
    m.vm.network "forwarded_port", guest: 8443, host: 8443
    m.vm.hostname = "master"
    m.vm.provision :docker
    m.vm.provision :docker_compose    

    m.vm.provider :virtualbox do |vb|
      vb.name = "jitsi"
      vb.memory = 2048
      vb.cpus = 2
      vb.check_guest_additions = false 
    end 
  end  
end
