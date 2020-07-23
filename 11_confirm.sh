#!/bin/bash
. ./setup.conf

echo "If the following commands do not complete in more than 30 minutes, it is likely that you did not prepare enough in advance or that you made a mistake."
echo "To watch its status, run e.g."
echo "ssh -i .ssh/id_rsa core@bootstrap journalctl -f"
echo "ssh -i .ssh/id_rsa core@master-0 journalctl -f"
echo "                     :"                 
echo "ssh -i .ssh/id_rsa core@worker-0 journalctl -f"
echo "                     :"                 

if [[ x$DEBUG_INSTALL == xY ]]; then
    LOG_LEVEL="--log-level=debug"
else
    LOG_LEVEL="--log-level=error"
fi

echo ./openshift-install --dir=bare-metal wait-for bootstrap-complete $LOG_LEVEL
./openshift-install --dir=bare-metal wait-for bootstrap-complete $LOG_LEVEL 2>&1 | egrep -v '^W'

date
