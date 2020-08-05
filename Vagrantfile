BOX_IMAGE = "generic/centos8"
DB_IP = "192.168.14.89"
BE1_IP = "192.168.14.88"
BE2_IP = "192.168.14.90"
LB_BE_IP = "192.168.14.70"
FE1_IP = "192.168.14.90"
FE2_IP = "192.168.14.91"
LB_FE_IP = "192.168.14.92"

Vagrant.configure("2") do |config|

  config.vm.define "db" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: DB_IP
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_db"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "db.sh"
  end

  config.vm.define "be1" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: BE1_IP
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_be1"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "be.sh", env: {"APP_IP" => BE1_IP, "DB_IP" => DB_IP}
  end

  config.vm.define "be2" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: BE2_IP
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_be2"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "be.sh", env: {"APP_IP" => BE2_IP, "DB_IP" => DB_IP}
  end

  config.vm.define "lb_be" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: LB_BE_IP
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_lb_be"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "lb.sh", env: {"APP1_IP" => BE1_IP, "APP2_IP" => BE2_IP}
  end

  config.vm.define "fe" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: FE1_IP
      subconfig.vm.synced_folder ".", "/vagrant"
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_front1"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "fe.sh", env: {"LB_BE_IP" => LB_BE_IP}
  end

  config.vm.define "fe" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: FE2_IP
      subconfig.vm.synced_folder ".", "/vagrant"
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_front2"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "fe.sh", env: {"LB_BE_IP" => LB_BE_IP}
  end

  config.vm.define "lb_be" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.network "private_network", ip: LB_FE_IP
      subconfig.vm.provider "virtualbox" do |vb|
          vb.name = "eschool_lb_fe"
          vb.memory = "512"
          vb.cpus = "1"
      end
      subconfig.vm.provision :shell, path: "lb.sh", env: {"APP1_IP" => FE1_IP, "APP2_IP" => FE2_IP}
  end

end
