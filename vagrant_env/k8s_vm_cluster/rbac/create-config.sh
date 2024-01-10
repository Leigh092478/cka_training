#!/bin/bash 

userName=$1
serverAddress=$2

if [[ -z "$userName" ]]; then
  echo "--> UserName and ServerAddress is required"
  read -p "userName : " userName

  kubectl cluster-info

  echo "--> You can get the Server Address in Kubernetes control plane Address"
  read -p "serverAddress : " serverAddress
fi

echo "--> Add cluster details to configuration file"
kubectl config --kubeconfig=$userName-kconfig set-cluster kubernetes --server=$serverAddress --insecure-skip-tls-verify=true

echo "--> Add user details to configuration file."
kubectl config --kubeconfig=$userName-kconfig set-credentials $userName --client-key=$userName.key --client-certificate=$userName.crt --embed-certs=true

echo "--> Add context details to configuration file."
kubectl config --kubeconfig=$userName-kconfig set-context $userName-context --cluster=kubernetes --user=$userName

echo "--> Set the context of configuration file."
kubectl config --kubeconfig=$userName-kconfig use-context $userName-context