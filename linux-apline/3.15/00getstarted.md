## 1. Konfigurasi IP Dinamis/Statik Pada NIC
aktifkan interface eth0
```sh
ifconfig eth0 up
```
Buka dan edit untuk hostname di /etc/network/interfaces
```sh interface
auto eth0
#iface eth0 inet dhcp
iface eth0 inet static
	address 9.9.9.3
	netmask 255.255.255.0
	gateway 9.9.9.99
```
Lakukan restart pada network
```sh term
# mengaktifkan interface
    ifconfig network-interface down
    ifconfig network-interface up
# merestart ip pada interface
    service networking restart
```
## 2. Merubah nama Host & Domain
DNS
```sh
echo "nameserver 8.8.8.8" >> /etc/resolv.conf && echo "nameserver 8.8.4.4" >> /etc/resolv.conf
```
buka dan edit untuk hostname di /etc/hostname
```sh file
echo "cnsatrain" > /etc/hostname
hostname -F /etc/hostname
```
buka dan edit untuk domain di /etc/hosts
```sh file
127.0.0.1       localhost
127.0.1.1       asepready.id      asepready

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```