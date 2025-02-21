# Worker Node Components
## A worker node has the following components:
- Container Runtime
- Node Agent - kubelet
- Proxy - kube-proxy
- Addons for DNS, Dashboard user interface, cluster-level monitoring and logging.

# IP
```sh
# check interfaces
ip link show
sudo ip link set enp7s0 up

#/etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
      addresses:
        - 192.168.122.130/24
      gateway4: 192.168.122.1
      nameservers:
          addresses: [8.8.8.8, 1.1.1.1]
    enp2s0:
      dhcp4: no
      addresses:
        - 172.16.1.12/24

sudo netplan apply
sudo ip link set enp7s0 up
ip addr show dev enp1s0

#/etc/hosts
127.0.0.1 localhost
172.16.1.10 master
172.16.1.11 worker1
172.16.1.12 worker2
```