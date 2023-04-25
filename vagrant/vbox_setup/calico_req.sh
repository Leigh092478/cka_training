#!/bin/bash
#

echo "****** Configuring kubectl ******"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "****** Installing Calico ********"
sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml

echo "****** Creating the necessary custom resource ********"
sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml

echo "****** Confirm that all of the pods are running ********"
watch kubectl get pods -n calico-system