#!/bin/bash
#

# "Run this file where the calico script is loacted"
echo "Installing calico manifest"
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml


echo "Wait until each pod has the STATUS of Running."
kubectl get pods -n calico-system -w

echo "Remove the taints on the control plane so that you can schedule pods on it."
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-


