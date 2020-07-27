export LANG=C

virsh list --all |awk '{print $2}'|grep -v Name | while read vm
do
    test -n "$vm" || continue

    case "$vm" in
	bootstrap | master-[0-9]* | worker-[0-9]*)
	    echo destroying $vm ...
	    virsh destroy $vm
	    virsh undefine --remove-all-storage $vm
	    ;;
	*)
	    echo skip $vm
	    ;;
    esac;
done

for N in $(virsh net-list --name --all | grep -v default); do
    virsh net-destroy ${N}  2>/dev/null
    virsh net-undefine ${N} 2>/dev/null
done 
ip a | grep ocp0-nic && nmcli d delete ocp0-nic
ip a | grep ocp0 &&  ( nmcli c delete ocp0; nmcli d delete ocp0 )



