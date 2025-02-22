## Rerensi Website
- [Ubuntu 18.04](https://www.hostafrica.com/blog/new-technologies/install-kubernetes-cluster-ubuntu-18/)
- [Ubuntu 24.04](https://medium.com/@saderi/quickly-set-up-a-multi-node-kubernetes-cluster-on-ubuntu-b7544c284b7b)
- [Ubuntu 24.04](https://www.hostafrica.com/blog/kubernetes/kubernetes-ubuntu-20-containerd/)

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


# 2. Worker Node Components
## A worker node has the following components:
- Container Runtime
- Node Agent - kubelet
- Proxy - kube-proxy
- Addons for DNS, Dashboard user interface, cluster-level monitoring and logging.
