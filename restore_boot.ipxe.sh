#!/bin/bash

ROLE=$1
if [ -z ${ROLE} ]
then
    echo "Failed: No role... ${ROLE}"
    exit
fi

while true
do
    echo -n "The ${ROLE} VM(s) are already booted ? <yes or no> "
    read ans
    if [ "X${ans}" = "Xyes" ]
    then
	break
    fi
done


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
