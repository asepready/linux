# Kubernetes V1.26 Installation with containerd container engine - Multi Node Cluster setup

```console
Step a : Create 3 VMs with Rocky Linux 9 OS. VM1: k8s-controlplane, VM2: k8s-workernode-1

$$ On k8s-controlplane node & workernodes  - perform below steps
Step b : containerd-installation
Step c : kubelet,kubectl,kubeadm installation
Step d : Reboot the VM

## Control Plane steps
Step e : Run kubeadm init and setup the control plane

$$ On k8s-workernode-1 - perform below steps
Step f : containerd-installation
Step g : kubelet,kubectl,kubeadm installation
Step h : Reboot the VM
Step i : Run kubeadm join command

```
# On k8s-controlplane & K8s-workernodes : Until step d
## Step b : containerd-installation
## How to install Containerd on Rocky OS
```console
Step 1 : Download & unpack containerd package
Step 2 : Install runc
Step 3 : Download & install CNI plugins
Step 4 : Configure containerd
Step 5 : Start containerd service
```

## Step 1 : Download & unpack containerd package

Containerd versions can be found in this location :  https://github.com/containerd/containerd/releases

### Download :
```bash
  wget https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz
```
### Unpack : 
```bash
  sudo tar Cxzvf /usr/local containerd-1.6.14-linux-amd64.tar.gz
```

## Step 2 : Install runc
Runc is a standardized runtime for spawning and running containers on Linux according to the OCI specification
```bash
  wget https://github.com/opencontainers/runc/releases/download/v1.1.3/runc.amd64
  sudo install -m 755 runc.amd64 /usr/local/sbin/runc
```

## Step 3: Download and install CNI plugins :

```bash
  wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
  sudo mkdir -p /opt/cni/bin
  sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz
```

## Step 4: Configure containerd

#### Create a containerd directory for the configuration file
#### config.toml is the default configuration file for containerd
#### Enable systemd group . Use sed command to change the parameter in config.toml instead of using vi editor 
####  Convert containerd into service
```bash
  sudo mkdir /etc/containerd
  containerd config default | sudo tee /etc/containerd/config.toml
  sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
  sudo curl -L https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -o /etc/systemd/system/containerd.service

# Enable IPv4 packet forwarding
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Disable SELinux
#/etc/selinux/config
SELINUX=permissive
#or
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# traffic control utility package:
sudo dnf install -y iproute-tc
```

## Step 5: Start containerd service
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
sudo systemctl status containerd    
```

# To come out of the promot , press q

## Step c : kubelet,kubectl,kubeadm installation
```bash
echo '
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
' | sudo tee /etc/yum.repos.d/kubernetes.repo

sudo dnf repolist
sudo dnf makecache
sudo dnf install kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

# Disable Swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo reboot now
```

## Step d: Run kubeadm init and setup the control plane
```bash
  sudo kubeadm init --ignore-preflight-errors=all
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  kubectl get nodes
  kubectl get pods --all-namespaces
  kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
  kubectl get pods --all-namespaces
  kubectl get nodes

# Control plane
sudo systemctl disable --now firewalld
sudo firewall-cmd --permanent --add-port={179,2379,2380,6443,10250,10251,10252,10257,10259}/tcp
sudo firewall-cmd --permanent --add-port=4789/udp
sudo firewall-cmd --reload
```

## On k8s-wn-1 node - perform below steps
 ```sh console
# node worker
sudo systemctl disable --now firewalld
sudo firewall-cmd --permanent --add-port={179,10250-10255,30000-32767}/tcp
sudo firewall-cmd --permanent --add-port=4789/udp
sudo firewall-cmd --reload

Step f : containerd-installation  [ Follow above containerd installation steps ]
Step g : kubelet,kubectl,kubeadm installation  [ Follow above steps - BUT PLZ DO NOT RUN KUBEADM INIT ON WORKERNODES . ITS ONLY ON MASTER NODE ]
Step h : Reboot the VM
Step i : Run kubeadm join command  [ Get the join command from master node ]
```

#### INSTALLATION COMPLETE
```sh
kubectl get nodes
# output
NAME             STATUS   ROLES           AGE     VERSION
control.master   Ready    control-plane   5m21s   v1.28.15
node01.worker    Ready    <none>          4m45s   v1.28.15
node02.worker    Ready    <none>          2m41s   v1.28.15

# set role
kubectl label node node01.worker node-role.kubernetes.io/worker=worker
kubectl label node node02.worker node-role.kubernetes.io/worker=worker

kubectl get nodes
# output
NAME             STATUS   ROLES           AGE   VERSION
control.master   Ready    control-plane   17m   v1.28.15
node01.worker    Ready    worker          16m   v1.28.15
node02.worker    Ready    worker          14m   v1.28.15
```
# 1 Master Node Components
## A master node runs the following control plane components:
- API Server
- Scheduler
- Controller Managers
- Data Store.

## In addition, the master node runs:
- Container Runtime
- Node Agent
- Proxy.

# 2 Worker Node Components
## A worker node has the following components:
- Container Runtime
- Node Agent - kubelet
- Proxy - kube-proxy
- Addons for DNS, Dashboard user interface, cluster-level monitoring and logging.
