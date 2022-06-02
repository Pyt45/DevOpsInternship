NUM_WORKER_NODES=1
IP_NW="10.0.0."
IP_START=10

Vagrant.configure("2") do |config|
    config.vm.provision "shell", env: {"IP_NW" => IP_NW, "IP_START" => IP_START}, inline: <<-SHELL
        echo "$IP_NW$((IP_START)) master" >> /etc/hosts
        echo "$IP_NW$((IP_START+1)) node0" >> /etc/hosts
        # echo "$IP_NW$((IP_START+2)) node1" >> /etc/hosts
    SHELL
    config.vm.box = "centos/8"
    config.vm.box_check_update = true

    config.vm.define "master" do |master|
        master.vm.hostname = "master"
        master.vm.network "private_network", ip: IP_NW + "#{IP_START}"
        master.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 1
        end
        master.vm.provider "shell", path: "common.sh"
        master.vm.provider "shell", path: "master.sh"
    end

    config.vm.define "node0" do |node|
        node.vm.hostname = "node0"
        node.vm.network "private_network", ip: IP_NW + "#{IP_START + 1}"
        node.vm.provider "virtualbox" do |vb|
            vb.memory = 512
            vb.cpus = 1
        end
        node.vm.provider "shell", path: "common.sh"
        node.vm.provider "shell", path: "node.sh"
    end
end