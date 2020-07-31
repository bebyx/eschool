BOX_IMAGE = "generic/centos8"

Vagrant.configure("2") do |config|

  config.vm.define "db" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: "192.168.14.89"
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_db"
          vb.memory = "1024"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "db.sh"
  end

  config.vm.define "app" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: "192.168.14.88"
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_app"
          vb.memory = "2068"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "app.sh"
  end

end
