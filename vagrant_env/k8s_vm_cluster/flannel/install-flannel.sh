#!/bin/bash

echo "Apply the flannel manifest"
kubectl apply -f kube-flannel.yml

echo "Wait for coredns and the flannel pods to come up"
kubectl get pods --namespace kube-system -w