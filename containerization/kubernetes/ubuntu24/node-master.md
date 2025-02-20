# Master Node Components
## A master node runs the following control plane components:
- API Server
- Scheduler
- Controller Managers
- Data Store.

## In addition, the master node runs:
- Container Runtime
- Node Agent
- Proxy.


# IP
```sh
#/etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
      addresses:
        - 192.168.122.128/24
      gateway4: 192.168.122.1
      nameservers:
          addresses: [8.8.8.8, 1.1.1.1]
    enp2s0:
      dhcp4: no
      addresses:
        - 172.16.1.10/24

sudo netplan apply
sudo ip link set enp7s0 up
ip addr show dev enp1s0

#/etc/hosts
127.0.0.1 localhost
172.16.1.10 master
172.16.1.11 worker1
172.16.1.12 worker2
```
