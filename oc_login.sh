#!/bin/bash -xv

export KUBECONFIG=$(find ~ -name kubeconfig | fgrep /bare-metal/)
oc login -u kubeadmin -p $(cat ~/openshift-fast-install/bare-metal/auth/kubeadmin-password)
