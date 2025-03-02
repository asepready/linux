```sh
#/etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp1s0:
      dhcp4: no
      addresses:
        - 192.168.122.10/24
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
192.168.122.10 control.master control
192.168.122.11 node01.worker node1
192.168.122.12 node02.worker node2
```
