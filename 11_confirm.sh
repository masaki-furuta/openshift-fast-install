#!/bin/bash
. ./setup.conf

echo "以下のコマンドが30分以上掛かっても完了しない場合は、事前準備が不足か間違っている可能性が高い"

echo ./openshift-install --dir=bare-metal wait-for bootstrap-complete
./openshift-install --dir=bare-metal wait-for bootstrap-complete

date
