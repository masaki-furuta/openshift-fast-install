#!/bin/bash

. ./setup.conf

ROLE=$1
if [ -z ${ROLE} ]
then
    echo "Failed: No role... ${ROLE}"
    exit
fi

if [[ x$AUTOMATIC_INSTALL != xY ]]; then
    while true
    do
        echo
        echo "Please check status of the ${ROLE} VM(s) with virsh console ${ROLE}."
        echo "Start VM(s) again when it's done and reboot(shutoff) ."
        read -p "The ${ROLE} VM(s) are already booted ? <yes or no> " ans
        if [ "X${ans}" = "Xyes" ]
        then
    	break
        fi
    done
fi
#sleep 25

case $ROLE in
    bootstrap)
	GREP="grep bootstrap"
	NUM=1
	;;
    master)
	GREP="egrep master-[012]"
	NUM=3
	;;
    worker)
	GREP="egrep worker-[01]"	
	NUM=2
	;;
    *)
	echo "Invalid args. $ROLE"
	exit
esac

while true
do
    VM=$(virsh list | ${GREP} | wc -l)

    if [ ${VM} -eq ${NUM} ]
    then
	break
    fi
    sleep 10
    echo sleeping...
done
	       
cp -p ./boot.ipxe /usr/share/nginx/html/ipxe/boot.ipxe
