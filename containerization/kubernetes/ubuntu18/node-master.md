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

sudo netplan apply
ip addr show dev enp1s0
```
