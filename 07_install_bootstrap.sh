#!/bin/bash

ROLE=bootstrap
cp -p boot.ipxe.${ROLE} /usr/share/nginx/html/ipxe/boot.ipxe

virt-install \
      --name bootstrap \
      --hvm \
      --virt-type kvm \
      --pxe \
      --arch x86_64 \
      --os-type linux \
      --os-variant rhel8.0 \
      --network network=ocp,mac="52:54:00:00:01:01" \
      --vcpus 4 \
      --ram 16384 \
      --disk pool=default,size=100,format=qcow2 \
      --check disk_size=off \
      --nographics \
      --noautoconsole \
      --boot menu=on,useserial=on

sh restore_boot.ipxe.sh ${ROLE}
