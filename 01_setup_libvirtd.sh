#!/bin/bash
#yum -y install libvirtd virt-install
yum -y install libvirt-daemon virt-install
virsh net-define ./ocp.xml
virsh net-start ocp
virsh net-autostart ocp

virsh net-list --all
