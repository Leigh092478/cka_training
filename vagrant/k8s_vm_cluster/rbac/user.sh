#!/bin/bash 

userName=$1
groupName=$2

if [[ -z "$userName" ]]; then
    echo "userName and groupName is required"
    read -p "userName :" userName
    read -p "groupName :" groupName
fi

echo "Creating $userName User Key and CSR file"
openssl genrsa -out $userName.key 2048
openssl req -new -key $userName.key -out $userName.csr -subj "/CN=${userName}/O=${groupName}"

if [ $? -eq 0 ]; then
    echo "Initializing succeeded"

    csrvar=$(cat vagrant-admin.csr | base64 | tr -d "\n")
	echo "$csrvar"

    echo "Create a CertificateSigningRequest"
    echo "apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${userName}-csr
spec:
  request: ${csrvar}
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 8640000  # one day
  usages:
  - client auth" >> vagrant-admin-cert.yaml
  
  ls -l

else
    echo "Creating User failed"
fi
