#!/usr/bin/bash

set -x

echo "Install packages"
/usr/bin/yum install epel-release git -y
/usr/bin/yum install ansible -y

echo "Install BlueBanquise"
/usr/bin/git clone https://github.com/bluebanquise/bluebanquise /etc/bluebanquise

# Copy the inventory
/usr/bin/cp -a /home/vagrant/profiles/* /etc/bluebanquise/

# Copy public key of the mgmt to the inventory
/usr/bin/sed -i -e "s#- ssh-rsa.*#- $(cat /root/.ssh/authorized_keys)#" \
  /etc/bluebanquise/inventory/group_vars/all/equipment_all/authentication.yml
