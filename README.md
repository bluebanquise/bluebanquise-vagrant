# BlueBanquise-Vagrant

This project aims to provide Vagrantfiles and inventories to use with
[Vagrant](https://www.vagrantup.com/).

It mainly targets the libvirt KVM hypervisor. However, it also provides
(limited) compatibility with VirtualBox.

## Pre-requisite

To setup your hypervisor, refer to your distribution documentation and the
[Vagrant installation guide](https://www.vagrantup.com/docs/installation).

To install the module vagrant-libvirt:

```
$ vagrant plugin install vagrant-libvirt
```

## Usage

Clone the project in a directory of your hypervisor. Enter the directory and
setup the configuration file `vagrant.yml`.

```
bluebanquise-vagrant$ cd tiny-hpc-cluster/
tiny-hpc-cluster$ cp vagrant.yml.example vagrant.yml
```

Edit the configuration file to match your needs. The profiles are kept in the
`profiles` directory. This project ships with a single profile, but you can add
any additional profiles in this directory. The name of the profile to use in
`vagrant.yml` is the name of the directory.

Once setup, run vagrant:

```
tiny-hpc-cluster$ vagrant status
tiny-hpc-cluster$ vagrant up <your_first_management_node>
tiny-hpc-cluster$ vagrant ssh
```
