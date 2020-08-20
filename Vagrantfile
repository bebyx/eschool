BOX_IMAGE = "gce"
DB_IP = "10.156.0.10"
BE1_IP = "10.156.0.11"
BE2_IP = "10.156.0.12"
LB_BE_IP = "10.156.0.13"
LB_BE_EXT_IP = "35.234.99.122" #Remember to make this static
FE1_IP = "10.172.0.14"
FE2_IP = "10.172.0.15"
LB_FE_IP = "10.172.0.16"
JENKINS_IP = "10.172.0.20"
G_PROJECT_ID = "trainingground-285720"
G_JSON = "/home/bebyx/.vagrant.d/trainingground-5ad01201922d.json"
SSH_USER = "bebyx"
SSH_KEY = "~/.ssh/id_rsa"

SSH_KEY_INSTANCE = IO.binread("/home/bebyx/.vagrant.d/ssh/id_rsa")
SSH_PUB_INSTANCE = IO.binread("/home/bebyx/.vagrant.d/ssh/id_rsa.pub")

Vagrant.configure("2") do |config|
  config.vm.box = BOX_IMAGE

  config.vm.define "db" do |subconfig|
    subconfig.vm.provider :google do |google, override|
        google.google_project_id = G_PROJECT_ID
        google.google_json_key_location = G_JSON

        google.zone = "europe-west3-c"
        google.zone_config "europe-west3-c" do |zone_config|
          zone_config.name = "eschool-db"
          zone_config.machine_type = "g1-small"
          zone_config.disk_size = "20"
          zone_config.image_family = "centos-8"
          zone_config.network_ip = DB_IP
        end

        override.vm.provision :shell, path: "db.sh"
        override.ssh.username = SSH_USER
        override.ssh.private_key_path = SSH_KEY

    end
  end

  config.vm.define "be1" do |subconfig|
    subconfig.vm.provider :google do |google, override|
        google.google_project_id = G_PROJECT_ID
        google.google_json_key_location = G_JSON

        google.zone = "europe-west3-c"
        google.zone_config "europe-west3-c" do |zone_config|
          zone_config.name = "eschool-be1"
          zone_config.machine_type = "g1-small"
          zone_config.disk_size = "20"
          zone_config.image_family = "centos-8"
          zone_config.network_ip = BE1_IP
        end

        override.ssh.username = SSH_USER
        override.ssh.private_key_path = SSH_KEY
        override.vm.provision :shell, path: "be.sh", env: {"APP_IP" => BE1_IP,
                                                           "DB_IP" => DB_IP,
                                                           "SSH_PUB_INSTANCE" => SSH_PUB_INSTANCE}
    end
  end

  config.vm.define "be2" do |subconfig|
    subconfig.vm.provider :google do |google, override|
        google.google_project_id = G_PROJECT_ID
        google.google_json_key_location = G_JSON

        google.zone = "europe-west3-c"
        google.zone_config "europe-west3-c" do |zone_config|
          zone_config.name = "eschool-be2"
          zone_config.machine_type = "g1-small"
          zone_config.disk_size = "20"
          zone_config.image_family = "centos-8"
          zone_config.network_ip = BE2_IP
        end

        override.ssh.username = SSH_USER
        override.ssh.private_key_path = SSH_KEY
        override.vm.provision :shell, path: "be.sh", env: {"APP_IP" => BE2_IP,
                                                           "DB_IP" => DB_IP,
                                                           "SSH_PUB_INSTANCE" => SSH_PUB_INSTANCE}
    end
  end

  config.vm.define "lb_be" do |subconfig|
    subconfig.vm.provider :google do |google, override|
        google.google_project_id = G_PROJECT_ID
        google.google_json_key_location = G_JSON
        google.tags = ['http-server']

        google.zone = "europe-west3-c"
        google.zone_config "europe-west3-c" do |zone_config|
          zone_config.name = "eschool-lb-be"
          zone_config.machine_type = "g1-small"
          zone_config.disk_size = "20"
          zone_config.image_family = "centos-8"
          zone_config.network_ip = LB_BE_IP
          zone_config.external_ip = LB_BE_EXT_IP
        end

        override.ssh.username = SSH_USER
        override.ssh.private_key_path = SSH_KEY
        override.vm.provision :shell, path: "lb.sh", env: {"APP1_IP" => BE1_IP,
                                                           "APP2_IP" => BE2_IP,
                                                           "PORT" => ":8080"}
    end
  end

  config.vm.define "fe1" do |subconfig|
    subconfig.vm.provider :google do |google, override|
        google.google_project_id = G_PROJECT_ID
        google.google_json_key_location = G_JSON

        google.zone = "europe-west6-c"
        google.zone_config "europe-west6-c" do |zone_config|
          zone_config.name = "eschool-fe1"
          zone_config.machine_type = "g1-small"
          zone_config.disk_size = "20"
          zone_config.image_family = "centos-8"
          zone_config.network_ip = FE1_IP
        end

        override.ssh.username = SSH_USER
        override.ssh.private_key_path = SSH_KEY
        override.vm.provision :shell, path: "fe.sh", env: {"LB_BE_EXT_IP" => LB_BE_EXT_IP,
                                                           "SSH_PUB_INSTANCE" => SSH_PUB_INSTANCE}
    end
  end

  config.vm.define "fe2" do |subconfig|
    subconfig.vm.provider :google do |google, override|
        google.google_project_id = G_PROJECT_ID
        google.google_json_key_location = G_JSON

        google.zone = "europe-west6-c"
        google.zone_config "europe-west6-c" do |zone_config|
          zone_config.name = "eschool-fe2"
          zone_config.machine_type = "g1-small"
          zone_config.disk_size = "20"
          zone_config.image_family = "centos-8"
          zone_config.network_ip = FE2_IP
        end

        override.ssh.username = SSH_USER
        override.ssh.private_key_path = SSH_KEY
        override.vm.provision :shell, path: "fe.sh", env: {"LB_BE_EXT_IP" => LB_BE_EXT_IP,
                                                           "SSH_PUB_INSTANCE" => SSH_PUB_INSTANCE}
    end
  end

  config.vm.define "lb_fe" do |subconfig|
    subconfig.vm.provider :google do |google, override|
        google.google_project_id = G_PROJECT_ID
        google.google_json_key_location = G_JSON
        google.tags = ['http-server']

        google.zone = "europe-west6-c"
        google.zone_config "europe-west6-c" do |zone_config|
          zone_config.name = "eschool-lb-fe"
          zone_config.machine_type = "g1-small"
          zone_config.disk_size = "20"
          zone_config.image_family = "centos-8"
          zone_config.network_ip = LB_FE_IP
        end

        override.ssh.username = SSH_USER
        override.ssh.private_key_path = SSH_KEY
        override.vm.provision :shell, path: "lb.sh", env: {"APP1_IP" => FE1_IP,
                                                           "APP2_IP" => FE2_IP,
                                                           "PORT" => ":80"}
    end
  end

    config.vm.define "jenkins" do |subconfig|
      subconfig.vm.provider :google do |google, override|
          google.google_project_id = G_PROJECT_ID
          google.google_json_key_location = G_JSON
          google.tags = ['http-server', 'jenkins']

          google.zone = "europe-west6-c"
          google.zone_config "europe-west6-c" do |zone_config|
            zone_config.name = "eschool-jenkins"
            zone_config.machine_type = "g1-small"
            zone_config.disk_size = "20"
            zone_config.image_family = "centos-8"
            zone_config.network_ip = JENKINS_IP
          end

          override.ssh.username = SSH_USER
          override.ssh.private_key_path = SSH_KEY
          override.vm.provision :shell, path: "jen.sh", env: {"SSH_KEY_INSTANCE" => SSH_KEY_INSTANCE,
                                                              "SSH_PUB_INSTANCE" => SSH_PUB_INSTANCE}
      end
    end

end
