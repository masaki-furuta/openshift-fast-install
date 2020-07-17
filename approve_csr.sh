#!/bin/bash -xv

export KUBECONFIG=$(find . -name kubeconfig | fgrep /bare-metal/)
oc get csr -o go-template='{{range .items}}{{if not .status}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | xargs oc adm certificate approve
oc get nodes
