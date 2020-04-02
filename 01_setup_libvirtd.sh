#!/bin/bash
#yum -y install libvirtd virt-install
yum -y install libvirt-daemon virt-install
virsh net-define ./ocp.xml
virsh net-start ocp
virsh net-autostart ocp

virsh net-list --all

grep bootstrap.test.lab.local. /etc/hosts && exit
cat << EOF >> /etc/hosts

172.16.0.100 bootstrap.test.lab.local.
192.168.122.216 pxe pxe.example.com

172.16.0.100 bootstrap
172.16.0.101 master-0
172.16.0.102 master-1
172.16.0.103 master-2
172.16.0.104 worker-0
172.16.0.105 worker-1
EOF
