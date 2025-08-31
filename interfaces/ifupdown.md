```sh
sudo apt install ifupdown

#/etc/network/interfaces
auto enp0s3
#iface enp0s3 inet dhcp
iface enp0s3 inet static
  address 192.168.1.100
  network 192.168.1.0
  netmask 255.255.255.0
  gateway 192.168.1.1
  dns-nameservers 8.8.8.8 8.8.4.4

#restart network
sudo systemctl restart networking
```
