# Vagrant
## To Connect on jumpbox

### Password
- vagrant

### Master
- ssh vagrant@master.local

### Nodes
- ssh vagrant@node1.local


# Tmux commands:
* Create new session: tmux
* Create new vertical pane: ctrl + b %
* Create new horizontal pane: ctrl + b “
* Switch to pane on the right: ctrl + b right arrow key
* Switch to pane on the left: ctrl + b left arrow key
* See pane index number: ctrl + b q
* Switch to pane index #: ctrl + b q <Index Number>
* Enter edit mode: ctrl + b [
* Exit edit mode: q (while in edit mode)
* Detach from a pane: ctrl + d

# Install Kubernetes:
### On master and worker node:
- sudo swapoff -a (check with free command)
    
#### Prepare pre-requisites:
- Install a container run time: https://kubernetes.io/docs/setup/production-environment/container-runtimes/
    - cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
      overlay
      br_netfilter
      EOF
    - sudo modprobe overlay
    - sudo modprobe br_netfilter
    - cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
      net.bridge.bridge-nf-call-iptables  = 1
      net.bridge.bridge-nf-call-ip6tables = 1
      net.ipv4.ip_forward                 = 1
      EOF
    - sudo sysctl --system
    - lsmod | grep br_netfilter
    - lsmod | grep overlay
    - sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
- sudo apt update && sudo apt install -y containerd
- sudo mkdir -p /etc/containerd
- sudo containerd config default | sudo tee /etc/containerd/config.toml
- sudo systemctl restart containerd

#### Install kubeadm: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl
- sudo mkdir -p /etc/apt/keyrings
- sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
- echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
- sudo apt update && sudo apt install -y kubelet=1.26.0-00 kubeadm=1.26.0-00 kubectl=1.26.0-00
- sudo apt-mark hold kubelet kubeadm kubectl

#### Initialize the cluster: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
- sudo kubeadm init --apiserver-advertise-address 192.168.56.5 --pod-network-cidr 192.168.0.0/16 --upload-certs --kubernetes-version 1.26.0


## Disable the Swap
- sudo vim /etc/fstab

## Installing Calico
- https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart