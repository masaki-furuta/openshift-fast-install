#!/bin/bash

. ./setup.conf

mkrole()
{
ROLE=$1
if [ -z ${ROLE} ]
then
    echo "Failed: No role... ${ROLE}"
    exit
fi

if [[ ${VERSION} =~ ^4\.+([6-9])\.+([0-9]) ]]
then
cat << EOF > boot.ipxe.${ROLE}
#!ipxe

# Variables are specified in boot.ipxe.cfg

# Figure out if client is 64-bit capable
cpuid --ext 29 && set arch x64 || set arch x86
cpuid --ext 29 && set archl amd64 || set archl i386

kernel  http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-kernel ip=dhcp rd.neednet=1 initrd=http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img console=tty0 console=ttyS0 coreos.inst=yes coreos.inst.insecure=yes coreos.inst.install_dev=vda coreos.live.rootfs_url=http://172.16.0.1:8000/ocp/rhcos/images/latest/bios.raw.gz coreos.inst.ignition_url=http://172.16.0.1:8000/ocp/rhcos/ignitions/${ROLE}.ign
initrd http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img
boot
EOF
else
cat << EOF > boot.ipxe.${ROLE}
#!ipxe

# Variables are specified in boot.ipxe.cfg

# Figure out if client is 64-bit capable
cpuid --ext 29 && set arch x64 || set arch x86
cpuid --ext 29 && set archl amd64 || set archl i386

kernel  http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-kernel ip=dhcp rd.neednet=1 initrd=http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img console=tty0 console=ttyS0 coreos.inst=yes coreos.inst.insecure=yes coreos.inst.install_dev=vda coreos.inst.image_url=http://172.16.0.1:8000/ocp/rhcos/images/latest/bios.raw.gz coreos.inst.ignition_url=http://172.16.0.1:8000/ocp/rhcos/ignitions/${ROLE}.ign
initrd http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img
boot
EOF
fi
}


mkrole bootstrap
mkrole master
mkrole worker

cat << EOF > boot.ipxe
#!ipxe

# Variables are specified in boot.ipxe.cfg

# Some menu defaults
set menu-timeout 5000
set submenu-timeout ${menu-timeout}
isset ${menu-default} || set menu-default exit

# Figure out if client is 64-bit capable
cpuid --ext 29 && set arch x64 || set arch x86
cpuid --ext 29 && set archl amd64 || set archl i386

###################### MAIN MENU ####################################

:start
menu iPXE boot menu
item --gap --             ------------------------- Operating systems ------------------------------
item --key b bootstrap    Boot bootstrap node
item --key m master       Boot master node
item --key w worker       Boot worker node
item --gap --             ------------------------- Advanced options -------------------------------
item --key c config       Configure settings
item shell                Drop to iPXE shell
item reboot               Reboot computer
item
item --key x exit         Exit iPXE and continue BIOS boot
choose --timeout 30000 --default ${menu-default} selected || goto cancel
goto ${selected}

:cancel
echo You cancelled the menu, dropping you to a shell

:shell
echo Type 'exit' to get the back to the menu
shell
set menu-timeout 0
set submenu-timeout 0
goto start

:failed
echo Booting failed, dropping to shell
goto shell

:reboot
reboot

:exit
exit

:config
config
goto start

:back
set submenu-timeout 0
clear submenu-default
goto start

:bootstrap
kernel  http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-kernel ip=dhcp rd.neednet=1 initrd=http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img console=tty0 console=ttyS0 coreos.inst=yes coreos.inst.insecure=yes coreos.inst.install_dev=vda coreos.inst.image_url=http://172.16.0.1:8000/ocp/rhcos/images/latest/bios.raw.gz coreos.inst.ignition_url=http://172.16.0.1:8000/ocp/rhcos/ignitions/bootstrap.ign
initrd http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img
boot

:master
kernel  http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-kernel ip=dhcp rd.neednet=1 initrd=http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img console=tty0 console=ttyS0 coreos.inst=yes coreos.inst.insecure=yes coreos.inst.install_dev=vda coreos.inst.image_url=http://172.16.0.1:8000/ocp/rhcos/images/latest/bios.raw.gz coreos.inst.ignition_url=http://172.16.0.1:8000/ocp/rhcos/ignitions/master.ign
initrd http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img
boot

:worker
kernel  http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-kernel ip=dhcp rd.neednet=1 initrd=http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img console=tty0 console=ttyS0 coreos.inst=yes coreos.inst.insecure=yes coreos.inst.install_dev=vda coreos.inst.image_url=http://172.16.0.1:8000/ocp/rhcos/images/latest/bios.raw.gz coreos.inst.ignition_url=http://172.16.0.1:8000/ocp/rhcos/ignitions/worker.ign
initrd http://172.16.0.1:8000/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img
boot
EOF
