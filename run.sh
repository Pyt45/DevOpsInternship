#!/usr/bin/env sh

os_type=$(uname -s) # ethier Darwin or Linux or Windows
which vagrant &> /dev/null
if [[ "$?" == "1" ]]; then
    if [[ $os_type == "Darwin" ]]; then
        # install vagrant
        which brew &> /dev/null
        if [ "$?" -eq 0 ]; then
            brew install vagrant
        else
            sudo apt install vagrant
        fi
    elif [[ $os_type == "Linux" ]]; then
        os=$(grep "^NAME" /etc/os-release | cut -d'=' -f2)
        if [[ $os == '"CentOS Linux"' ]]; then
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            sudo yum -y install vagrant
        else [[ $os == '"Ubuntu"' ]]; then
            curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
            sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
            sudo apt-get update && sudo apt-get install vagrant
        else
            echo "for other installation go a head to: "
            echo "https://www.vagrantup.com/downloads"
        fi
    fi

    echo "For windows installation go a head to: "
    echo "https://www.vagrantup.com/downloads"
fi

rm -rf .vagrant
rm configs/config
rm configs/join.sh

sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*