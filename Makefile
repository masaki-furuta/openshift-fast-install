.PHONY: all approve sb sm sw clean distclean

all:
	/bin/time -p ./00_all.sh

config:
	./create_setup.conf.sh

approve:
	./approve_csr.sh

force-approve:
	KUBECONFIG=$(shell find . -name kubeconfig | fgrep /bare-metal/);oc get csr -o name | xargs oc adm certificate approve

sb:
	virsh start bootstrap

sm:
	virsh start master-0; virsh start master-1; virsh start master-2; exit 0

sw:
	virsh start worker-0; virsh start worker-1; exit 0

rb:
	virsh shutdown bootstrap

vcb:
	virsh console bootstrap

vcm:
	virsh console master-0

vcm1:
	virsh console master-1

vcm2:
	virsh console master-2

vcw:
	virsh console worker-0

vcw1:
	virsh console worker-1

watch:
	KUBECONFIG=$(shell find . -name kubeconfig | fgrep /bare-metal/);watch -n1 "oc get nodes;echo;echo;oc get csr;echo;echo;oc get clusterversion;echo;echo;virsh list "

clean:
	./destroy_env.sh; exit 0
	rm -rfv boot.* ocp.xml etc_conf/dhcpd.conf etc_conf/coredns openshift-{client,installer}-linux* /usr/share/nginx/html/{ocp,ipxe} /usr/local/bin/{kubectl,oc} /var/lib/libvirt/images/{bootstrap,master,worker}*.qcow2 /root/bin/{openshift-install,oc,kubectl} /etc/dnsmasq.d/*.conf; exit 0
	dnf -q -y remove rsawaroha-release xsos rsar @virtualization-platform @virtualization-client @virtualization-tools nginx lshw ipcalc bc 2>/dev/null; exit 0

distclean: clean
	rm -fv setup.conf; exit 0


