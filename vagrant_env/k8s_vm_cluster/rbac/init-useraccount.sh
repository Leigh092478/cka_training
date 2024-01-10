#!/bin/bash 

userName=$1
groupName=$2

if [[ -z "$userName" ]]; then
  echo "--> UserName and GroupName is required"
  read -p "userName : " userName
  read -p "groupName : " groupName
fi

echo "--> Creating $userName User Key and CSR file"
openssl genrsa -out $userName.key 2048
openssl req -new -key $userName.key -out $userName.csr -subj "/CN=${userName}/O=${groupName}"

if [ $? -eq 0 ]; then
  echo "--> $userName User Key and CSR Created"

  csrvar=$(cat vagrant-admin.csr | base64 | tr -d "\n")

  echo "--> Create a CertificateSigningRequest"
  echo "apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${userName}-csr
spec:
  request: ${csrvar}
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 8640000  # one day
  usages:
  - client auth" >> /vagrant/yaml_files/${userName}-csr.yaml
  
  echo "--> Apply and Approve the Certificate"
  kubectl apply -f /vagrant/yaml_files/${userName}-csr.yaml

  kubectl get csr

  kubectl certificate approve ${userName}-csr

  echo "--> Export the issued certificate from the CertificateSigningRequest."
  kubectl get csr ${userName}-csr -o jsonpath='{.status.certificate}'| base64 -d > ${userName}.crt

  ls -l

  echo "Done Initializng User Account : ${userName}" 
else
  echo "Creating User failed"
fi