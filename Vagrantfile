Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.provision "shell", path: "bootstrap.sh"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 4
  end

  # === Port Forwards ===
  
  # Kubernetes API server
  config.vm.network "forwarded_port", guest: 6443, host: 6443

  # HTTP/HTTPS
  config.vm.network "forwarded_port", guest: 80, host: 10080
  config.vm.network "forwarded_port", guest: 443, host: 10443
end
