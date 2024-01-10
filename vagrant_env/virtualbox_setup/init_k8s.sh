#!/bin/bash
#

echo "Initializing Kubeadm"
sudo kubeadm init --apiserver-advertise-address 192.168.56.5 --kubernetes-version 1.27.0 --pod-network-cidr 10.244.0.0/16 -v 5
if [ $? -eq 0 ]; then
    echo "Initializing succeeded"

    mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config

else
    echo "Initializing failed"
fi