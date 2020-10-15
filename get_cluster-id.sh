#!/bin/bash -xv

export KUBECONFIG=$(find ~ -name kubeconfig | fgrep /bare-metal/)
oc get clusterversion -o jsonpath='{.items[].spec.clusterID}{"\n"}'
