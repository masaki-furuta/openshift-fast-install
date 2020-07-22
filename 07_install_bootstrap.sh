#!/bin/bash

. ./setup.conf

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
      --vcpus ${BCPU} \
      --ram ${BRAM} \
      --disk pool=default,size=${BDISK},format=qcow2 \
      --check disk_size=off \
      --nographics \
      --noautoconsole \
      --boot menu=on,useserial=on

if [[ x$AUTOMATIC_INSTALL == xY ]]; then
    VM_LST=bootstrap
    VM_RGX=$VM_LST
    
    if [[ $(virsh list --name | egrep -c "${VM_RGX}") -ge 0 ]]; then
        for N in $(virsh list --name | egrep "${VM_RGX}"); do
    	    while true; do
    		virsh list | grep -q "${N}"|| break
    		sleep 5
    		echo -n .
    	    done
        done
    fi
    
    sleep 2
    echo -en "\nInstall Done!\nRebooting..\n"
    for N in ${VM_LST}; do
        virsh start ${N}
    done
    
    for N in $(virsh list --name | egrep "${VM_RGX}"); do
        while true; do
    	    echo
    	    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null core@${N} exit 2>/dev/null && break
    	    sleep 5
    	    echo -n .
        done
    done
    
    echo "Reboot Done!"
fi

sh restore_boot.ipxe.sh ${ROLE}
