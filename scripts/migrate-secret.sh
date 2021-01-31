#!/bin/bash

kubectl --kubeconfig=$HOME/.kube/legacy-config -n vis-staging get secret $1 -o yaml > /tmp/secret.yml &&
sed -i -e 's/vis-staging/staging-115/g' /tmp/secret.yml &&
kubectl -n staging-115 apply -f /tmp/secret.yml &&
kubectl -n staging-115 annotate secret $1 kubectl.kubernetes.io/last-applied-configuration-&&
rm /tmp/secret.yml

