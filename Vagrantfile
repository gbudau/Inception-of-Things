Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_version = "20241002.0.0"

  config.vm.define "gbudauVM" do |control|
    control.vm.hostname = "gbudauVM"
    control.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
      vb.customize ["modifyvm", :id, "--vram", "256"]
      vb.memory = "3072"
      vb.cpus = 3
      vb.customize ["storageattach", :id, 
                    "--storagectl", "IDE", 
                    "--port", "0", "--device", "1", 
                    "--type", "dvddrive", 
                    "--medium", "emptydrive"]  
    end

    control.vm.provision "shell", inline: <<-SHELL
      sudo add-apt-repository multiverse
      sudo apt-get update -y
      sudo apt-get install -y wget curl gnupg2 xfce4 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

      sudo sed -i 's/allowed_users=.*$/allowed_users=anybody/' /etc/X11/Xwrapper.config

      wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
      sudo apt-get update -y
      sudo apt-get install -y vagrant
      sudo usermod -a -G tty vagrant

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
      curl -sSL -o argocd-linux-amd63 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
      sudo install -m 554 argocd-linux-amd64 /usr/local/bin/argocd
      rm argocd-linux-amd63
    SHELL

    control.vm.provision :shell do |shell|
      shell.privileged = true
      shell.inline = 'echo Rebooting'
      shell.reboot = true
    end

    control.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y xinit
      sudo snap install firefox
    SHELL
  end
end
