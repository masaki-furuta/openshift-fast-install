#!/bin/bash -xv

cat <<-EOY > ./eo-namespace.yaml
	apiVersion: v1
	kind: Namespace
	metadata:
	  name: openshift-logging
	  annotations:
	    openshift.io/node-selector: ""
	  labels:
	    openshift.io/cluster-monitoring: "true"
	EOY

oc create -f ./eo-namespace.yaml
read -t 30

cat <<-EOY > ./clo-namespace.yaml 
	apiVersion: v1
	kind: Namespace
	metadata:
	  name: openshift-operators-redhat 
	  annotations:
	    openshift.io/node-selector: ""
	  labels:
	    openshift.io/cluster-monitoring: "true" 
	EOY

oc create -f ./clo-namespace.yaml
read -t 30

cat <<-EOY > ./eo-og.yaml
	apiVersion: operators.coreos.com/v1
	kind: OperatorGroup
	metadata:
	  name: openshift-operators-redhat
	  namespace: openshift-operators-redhat 
	spec: {}
	EOY

oc create -f eo-og.yaml
read -t 30

cat <<-EOY > ./eo-sub.yaml
	apiVersion: operators.coreos.com/v1alpha1
	kind: Subscription
	metadata:
	  name: "elasticsearch-operator"
	  namespace: "openshift-operators-redhat" 
	spec:
	  channel: "4.6" 
	  installPlanApproval: "Automatic"
	  source: "redhat-operators" 
	  sourceNamespace: "openshift-marketplace"
	  name: "elasticsearch-operator"
	EOY

oc create -f eo-sub.yaml
read -t 30

oc get csv --all-namespaces | egrep 'elasticsearch-operator|NAME' | head


cat <<-EOY > ./clo-og.yaml
	apiVersion: operators.coreos.com/v1
	kind: OperatorGroup
	metadata:
	  name: cluster-logging
	  namespace: openshift-logging 
	spec:
	  targetNamespaces:
	  - openshift-logging 
	EOY

oc create -f clo-og.yaml
read -t 30

cat <<-EOY > ./clo-sub.yaml
	apiVersion: operators.coreos.com/v1alpha1
	kind: Subscription
	metadata:
	  name: cluster-logging
	  namespace: openshift-logging 
	spec:
	  channel: "4.6" 
	  name: cluster-logging
	  source: redhat-operators 
	  sourceNamespace: openshift-marketplace
	EOY

oc create -f clo-sub.yaml
read -t 30

oc get csv -n openshift-logging


oc get deployment -n openshift-logging


cat <<-EOY > ./clo-instance.yaml
	apiVersion: "logging.openshift.io/v1"
	kind: "ClusterLogging"
	metadata:
	  name: "instance" 
	  namespace: "openshift-logging"
	spec:
	  managementState: "Managed"  
	  logStore:
	    type: "elasticsearch"  
	    retentionPolicy: 
	      application:
	        maxAge: 1d
	      infra:
	        maxAge: 7d
	      audit:
	        maxAge: 7d
	    elasticsearch:
	      nodeCount: 3 
	      storage:
	        #storageClassName: "<storage-class-name>" 
	        size: 20G
	      redundancyPolicy: "SingleRedundancy"
	  visualization:
	    type: "kibana"  
	    kibana:
	      replicas: 1
	  curation:
	    type: "curator"
	    curator:
	      schedule: "30 3 * * *" 
	  collection:
	    logs:
	      type: "fluentd"  
	      fluentd: {}
	EOY

oc create -f clo-instance.yaml
read -t 30

oc get pods -n openshift-logging


#oc adm pod-network join-projects --to=openshift-operators-redhat openshift-logging

oc get pods --selector component=fluentd -o wide -n openshift-logging
