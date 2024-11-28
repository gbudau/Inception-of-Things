Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.box_version = "12.20240905.1"

  config.vm.define "gbudauVM" do |control|
    control.vm.hostname = "gbudauVM"
    control.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
      vb.customize ["modifyvm", :id, "--vram", "256"]
      vb.memory = "3072"
      vb.cpus = 3
    end

    control.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y wget curl gnupg2 xfce4 accountsservice

      sudo sed -i 's/allowed_users=.*$/allowed_users=anybody/' /etc/X11/Xwrapper.config

      wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
      sudo apt-get update -y
      sudo apt-get install -y vagrant
      sudo usermod -a -G tty vagrant
      # Set password for vagrant user to be able to login using GUI
      echo -e 'vagrant\nvagrant\n' | sudo passwd vagrant

      echo deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib | sudo tee /etc/apt/sources.list.d/virtualbox.list
      wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor
      sudo apt-get update -y
      sudo apt-get install -y virtualbox-7.0
      sudo apt-get install -y linux-headers-$(uname -r)
      sudo /sbin/vboxconfig

      # Install Docker
      curl -fsSL https://get.docker.com | sh -
      sudo usermod -aG docker vagrant
      newgrp docker
        
      # Install kubectl
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        
      # Install k3d
      curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

      # Install ArgoCD CLI
      VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
      curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
      sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
      rm argocd-linux-amd64

    SHELL

    control.vm.provision :shell do |shell|
      shell.privileged = true
      shell.inline = 'echo Rebooting'
      shell.reboot = true
    end

    control.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y firefox-esr
    SHELL
  end
end
