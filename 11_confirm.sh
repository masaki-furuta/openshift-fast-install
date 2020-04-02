#!/bin/bash
. ./setup.conf

echo "以下のコマンドが30分以上掛かっても完了しない場合は、事前準備が不足か間違っている可能性が高い"
echo "To watch its status, run e.g."
echo "ssh -i .ssh/id_rsa core@bootstrap journalctl -f"
echo "ssh -i .ssh/id_rsa core@master-0 journalctl -f"
echo "                     :"                 
echo "ssh -i .ssh/id_rsa core@worker-0 journalctl -f"
echo "                     :"                 

echo ./openshift-install --dir=bare-metal wait-for bootstrap-complete --log-level=debug
./openshift-install --dir=bare-metal wait-for bootstrap-complete --log-level=debug

date
