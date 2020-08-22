#!/usr/bin/bash

set -x

echo "Install packages"
/usr/bin/dnf install epel-release git wget redhat-lsb-core -y
/usr/bin/dnf install ansible -y

DISTRIBUTION=$(lsb_release -is|tr '[:upper:]' '[:lower:]')
RELEASE=$(lsb_release -rs)
MAJOR_RELEASE=${RELEASE:0:1}
MINOR_RELEASE=${RELEASE:0:3}
ARCH=$(uname -i)

echo "Install BlueBanquise and dependencies"
/usr/bin/git clone https://github.com/bluebanquise/bluebanquise /etc/bluebanquise
/usr/bin/dnf install clustershell -y

echo "Setup the simple_cluster environment"
# os repository
/usr/bin/mkdir -p /var/www/html/repositories/${DISTRIBUTION}/${MAJOR_RELEASE}/${ARCH}/os/
/usr/bin/mount /dev/cdrom /var/www/html/repositories/${DISTRIBUTION}/${MAJOR_RELEASE}/${ARCH}/os/

# Download bluebanquise repository if we don't have a local copy
if [[ ! -d /var/www/html/repositories/${DISTRIBUTION}/${MAJOR_RELEASE}/${ARCH}/bluebanquise/ ]]; then
    (cd /var/www/html/repositories/${DISTRIBUTION}/${MAJOR_RELEASE}/${ARCH}/ && /usr/bin/wget -q -rkp -l2 -np -nH -R "index.html*" -R "*.gif" --cut-dirs=3 https://bluebanquise.com/repository/el${MAJOR_RELEASE}/${ARCH}/bluebanquise/)
fi
/usr/sbin/restorecon -Rv /var/www/html/repositories/${DISTRIBUTION}/${MAJOR_RELEASE}/${ARCH}/bluebanquise

# Copy the inventory
/usr/bin/cp -a /home/vagrant/profiles/* /etc/bluebanquise/

# Create software share for NFS
/usr/bin/mkdir -p /opt/softwares

# Copy public key of the mgmt to the inventory
/usr/bin/sed -i -e "s#- ssh-rsa.*#- $(cat /root/.ssh/authorized_keys)#" \
  /etc/bluebanquise/inventory/group_vars/all/equipment_all/authentication.yml

echo "Set the distribution release"
/usr/bin/sed -i -e "s/distribution_major_version: ./distribution_major_version: ${MAJOR_RELEASE}/" \
                -e "/distribution_version: .*/d" \
                -e "s/distribution: .*/distribution: ${DISTRIBUTION}/" \
                /etc/bluebanquise/inventory/group_vars/equipment_typeM/equipment_profile.yml
/usr/bin/sed -i -e "s/distribution_major_version: ./distribution_major_version: ${MAJOR_RELEASE}/" \
                -e "/distribution_version: .*/d" \
                -e "s/distribution: .*/distribution: ${DISTRIBUTION}/" \
                /etc/bluebanquise/inventory/group_vars/equipment_typeC/equipment_profile.yml
/usr/bin/sed -i -e "s/distribution_major_version: ./distribution_major_version: ${MAJOR_RELEASE}/" \
                -e "/distribution_version: .*/d" \
                -e "s/distribution: .*/distribution: ${DISTRIBUTION}/" \
                /etc/bluebanquise/inventory/group_vars/equipment_typeL/equipment_profile.yml
