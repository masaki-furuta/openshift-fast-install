#!/bin/bash
. ./setup.conf

SLEEP=30

retry_oc () {

    CMDS=$*
    echo "${CMDS}"
    ${CMDS}

    STAT=$?
    while [ ${STAT} -ne 0 ]
    do
	echo sleeping ${SLEEP} sec...
	sleep ${SLEEP}
	echo "${CMDS} - again"
	${CMDS}
	STAT=$?
    done

    echo
    date
    echo
    
}

export KUBECONFIG=$(find ~ -name kubeconfig | fgrep /bare-metal/)

retry_oc oc whoami
retry_oc oc get nodes
retry_oc oc get csr

echo retry_oc oc patch configs.imageregistry.operator.openshift.io/cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'
retry_oc oc patch configs.imageregistry.operator.openshift.io/cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'

retry_oc oc get csr

RESULT=/tmp/oc_get_clusteroperators.out
STAT=0
while [ $STAT -ne 1 ]
do
    retry_oc oc get clusteroperators > $RESULT
    cat $RESULT
    cat $RESULT | egrep "True|False|Unknown" | grep -v "True        False         False"
    STAT=$?
    echo sleeping ${SLEEP} sec...
    sleep ${SLEEP}
    echo
done

retry_oc sudo ./openshift-install --dir=bare-metal wait-for install-complete

echo try access https://console-openshift-console.apps.test.lab.local using Firefox
echo "About username and passwd, you can find out the the last openshift-install command output"
echo "e.g. kubeadmin/4GQVz-NeK4K-bdxG5-SGRxd"
echo
