#!/bin/bash

. ./setup.conf

ROLE=worker
cp -p boot.ipxe.${ROLE} /usr/share/nginx/html/ipxe/boot.ipxe

for i in `seq 0 $((${WORKERS}-1))`; do
    mac=$((i+5))
    virt-install \
      --name worker-$i \
      --hvm \
      --virt-type kvm \
      --pxe \
      --arch x86_64 \
      --os-type linux \
      --os-variant rhel8.0 \
      --network network=ocp,mac="52:54:00:00:01:0${mac}" \
      --vcpus ${MCPU} \
      --ram ${MRAM} \
      --disk pool=default,size=${MDISK},format=qcow2 \
      --check disk_size=off \
      --nographics \
      --noautoconsole \
      --boot menu=on,useserial=on
done

sh restore_boot.ipxe.sh $ROLE
