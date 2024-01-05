#!/bin/bash
#

echo "Apply the flannel manifest"
sudo kubectl apply -f kube-flannel.yml

echo "Wait for coredns and the flannel pods to come up"
sudo kubectl get pods --namespace kube-system -w

echo "Once all pods are up, lets check the status of our nodes"
sudo kubectl get nodes