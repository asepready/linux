## Rerensi Website
- [Ubuntu 18.04](https://www.hostafrica.com/blog/new-technologies/install-kubernetes-cluster-ubuntu-18/)
- [Ubuntu 24.04](https://medium.com/@saderi/quickly-set-up-a-multi-node-kubernetes-cluster-on-ubuntu-b7544c284b7b)

# 1. Master Node Components (Control Plane)
## A master node runs the following control plane components:
- API Server
- Scheduler
- Controller Managers
- Data Store.

## In addition, the master node runs:
- Container Runtime
- Node Agent
- Proxy.

```sh
# Step 1: Enable IPv4 packet forwarding
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

sudo sysctl --system # Apply sysctl params without reboot


# Step 2: Disable swap
# Disable swap immediately
sudo swapoff -a

# Prevent swap from re-enabling after reboot
sudo sed -i '/swap/d' /etc/fstab

# Step 3: Install containerd as the Container Runtime
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y containerd.io

sudo containerd config default | sudo tee /etc/containerd/config.toml
#/etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
--- add line
    SystemdCgroup = true


sudo systemctl restart containerd
ps -ef | grep containerd

# Step 4: Install Kubernetes Components
sudo apt install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet

# Step 5: Initialize the Kubernetes Control Plane
sudo ufw allow 6443/tcp
sudo ufw allow 2379/tcp
sudo ufw allow 2380/tcp
sudo ufw allow 10250/tcp
sudo ufw allow 10251/tcp
sudo ufw allow 10252/tcp
sudo ufw allow 10255/tcp
sudo ufw reload

sudo kubeadm config images pull
sudo kubeadm init --pod-network-cidr=10.10.0.0/16

### Massage ###
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.122.128:6443 --token 9qxrgm.ry3co7oseb03xq0b \
	--discovery-token-ca-cert-hash sha256:d485791d5bb4e0646771f17b5275103df375e391f2a29f3ab5cb1e3c3f782bdc 

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
### END Massage ###

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes 

# Step 6: Install Weave Net for Pod Networking
curl -fsSL https://reweave.azurewebsites.net/k8s/v1.31/net.yaml -o weave-net.yaml

# edit file weave-net.yaml
      containers:
        - name: weave
          env:
            - name: IPALLOC_RANGE
              value: 10.10.0.0/16 # Replace with your chosen CIDR

kubectl apply -f weave-net.yaml

# Step 7: Install worker nodes and join the cluster
sudo kubeadm token create --print-join-command

# Step 8: Verify the cluster
kubectl get nodes

```
# 2. Worker Node Components
## A worker node has the following components:
- Container Runtime
- Node Agent - kubelet
- Proxy - kube-proxy
- Addons for DNS, Dashboard user interface, cluster-level monitoring and logging.
```sh
sudo ufw allow 10251/tcp
sudo ufw allow 10255/tcp
sudo ufw reload
```