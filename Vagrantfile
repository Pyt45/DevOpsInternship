NUM_WORKER_NODES=4
IP_NW="192.168.42."
IP_START=110

Vagrant.configure("2") do |config|
    config.vm.provision "shell", env: {"IP_NW" => IP_NW, "IP_START" => IP_START}, inline: <<-SHELL
        echo "$IP_NW$((IP_START)) master" >> /etc/hosts
        echo "$IP_NW$((IP_START+1)) node0" >> /etc/hosts
        echo "$IP_NW$((IP_START+2)) node1" >> /etc/hosts
        echo "$IP_NW$((IP_START+3)) node2" >> /etc/hosts
        echo "$IP_NW$((IP_START+4)) node3" >> /etc/hosts
    SHELL
    config.vm.box = "generic/centos7"
    config.vm.box_check_update = true
    
    config.vm.define "master" do |master|
        master.vm.hostname = "master"
        master.vm.network "private_network", ip: IP_NW + "#{IP_START}"
        master.vm.synced_folder "configs", "/vagrant"
        master.vm.provider "virtualbox" do |vb|
            vb.memory = 4096
            vb.cpus = 2
            vb.customize ["modifyvm", :id, "--name", "master"]
            # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
            # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        end
        master.vm.provision "shell", path: "common.sh"
        master.vm.provision "shell", path: "master.sh"
    end

    config.vm.define "node0" do |node|
        node.vm.hostname = "node0"
        node.vm.network "private_network", ip: IP_NW + "#{IP_START + 1}"
        node.vm.synced_folder "configs", "/vagrant"
        node.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 1
            vb.customize ["modifyvm", :id, "--name", "node0"]
        end
        node.vm.provision "shell", path: "common.sh"
        node.vm.provision "shell", path: "node.sh"
    end
    config.vm.define "node1" do |node|
        node.vm.hostname = "node1"
        node.vm.network "private_network", ip: IP_NW + "#{IP_START + 2}"
        node.vm.synced_folder "configs", "/vagrant"
        node.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 1
            vb.customize ["modifyvm", :id, "--name", "node1"]
        end
        node.vm.provision "shell", path: "common.sh"
        node.vm.provision "shell", path: "node.sh"
    end
    config.vm.define "node2" do |node|
        node.vm.hostname = "node2"
        node.vm.network "private_network", ip: IP_NW + "#{IP_START + 3}"
        node.vm.synced_folder "configs", "/vagrant"
        node.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 1
            vb.customize ["modifyvm", :id, "--name", "node2"]
        end
        node.vm.provision "shell", path: "common.sh"
        node.vm.provision "shell", path: "node.sh"
    end
    config.vm.define "node3" do |node|
        node.vm.hostname = "node3"
        node.vm.network "private_network", ip: IP_NW + "#{IP_START + 4}"
        node.vm.synced_folder "configs", "/vagrant"
        node.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 1
            vb.customize ["modifyvm", :id, "--name", "node3"]
        end
        node.vm.provision "shell", path: "common.sh"
        node.vm.provision "shell", path: "node.sh"
    end
    # (1..NUM_WORKER_NODES).each do |i|
    #     config.vm.define "node#{i}" do |node|
    #         node.vm.hostname = "node#{i}"
    #         node.vm.network "private_network", ip: IP_NW + "#{IP_START + i}"
    #         node.vm.synced_folder "configs", "/vagrant"
    #         node.vm.provider "virtualbox" do |vb|
    #             vb.memory = 2048
    #             vb.cpus = 1
    #             vb.customize ["modifyvm", :id, "--name", "node#{i}"]
    #         end
    #         node.vm.provision "shell", path: "common.sh"
    #         node.vm.provision "shell", path: "node.sh"
    #     end
    # end
end