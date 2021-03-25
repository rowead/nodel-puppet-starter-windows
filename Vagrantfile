# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  config.vm.define "nw10" do |nw10|
    #nw10.vm.box = "gusztavvargadr/windows-10"
    nw10.vm.box = "fishi0x01/win-10-pro-x64"
    #nw10.vm.box_version = "1.0"
    nw10.vm.hostname = "wam-dev-foyer-wm03"
    nw10.vm.synced_folder "./", "C:\\puppet", type: "virtualbox"
    nw10.vm.network "forwarded_port", guest: 8085, host: 8085
    #nw10.vm.network "private_network", type: "dhcp"
    nw10.vm.provider "virtualbox" do |nw10vb|
      nw10vb.memory = "4096"
      nw10vb.cpus = 2
      nw10vb.gui = true
    end

    nw10.vm.provision "shell", path: "./shell/install-puppet-vagrant.ps1"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

end