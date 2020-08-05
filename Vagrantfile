BOX_IMAGE = "generic/centos8"
APP1_IP = "192.168.14.88"
APP2_IP = "192.168.14.90"
LB_BE_IP = "192.168.14.70"

Vagrant.configure("2") do |config|

  config.vm.define "db" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: "192.168.14.89"
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_db"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "db.sh"
  end

  config.vm.define "app1" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: APP1_IP
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_app1"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "app.sh", env: {"APP_IP" => APP1_IP}
  end

  config.vm.define "app2" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: APP2_IP
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_app2"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "app.sh", env: {"APP_IP" => APP2_IP}
  end

  config.vm.define "lb_be" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: LB_BE_IP
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_lb_be"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "lb_be.sh"
  end

  config.vm.define "fe" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: "192.168.14.90"
      subconfig.vm.synced_folder ".", "/vagrant"
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_front"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "fe.sh", env: {"LB_BE_IP" => LB_BE_IP}
  end


end
