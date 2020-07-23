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

export KUBECONFIG=$(find . -name kubeconfig | fgrep /bare-metal/)

retry_oc oc whoami
retry_oc oc get nodes

echo retry_oc oc patch configs.imageregistry.operator.openshift.io/cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'
retry_oc oc patch configs.imageregistry.operator.openshift.io/cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'

RESULT=/tmp/oc_get_clusteroperators.out
STAT=0
while [ $STAT -ne 1 ]
do
    ./approve_csr.sh
    retry_oc oc get clusteroperators > $RESULT
    cat $RESULT
    cat $RESULT | egrep "True|False|Unknown" | grep -v "True        False         False"
    STAT=$?
    echo sleeping ${SLEEP} sec...
    sleep ${SLEEP}
    echo
done


if [[ x$DEBUG_INSTALL == xY ]]; then
    LOG_LEVEL="--log-level=debug"
else
    LOG_LEVEL="--log-level=error"
fi

retry_oc sudo ./openshift-install --dir=bare-metal wait-for install-complete $LOG_LEVEL
./approve_csr.sh
retry_oc oc get nodes
retry_oc oc get csr

echo try access https://console-openshift-console.apps.test.lab.local using browser.
echo "About username and passwd, you can find out the the last openshift-install command output"

./show_kubeadmin_password.sh
