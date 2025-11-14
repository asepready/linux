```sh
apt-get install ifenslave ethtool
invoke.rc.d networking stop

cat > /etc/network/interfaces << EOF
# change all like follows
# replace the interface name, IP address, DNS, Gateway to your environment value
# for [mode] section, set a mode you'd like to use
auto ens3
iface ens3 inet manual
  bond-master bond0
  bond-mode balance-rr

auto ens4
iface ens4 inet manual
  bond-master bond0
  bond-mode balance-rr

auto bond0
iface bond0 inet static
  address 10.0.137.1
  netmask 255.255.255.0
  network 10.0.137.0
  gateway 10.0.137.1
  bond-slaves ens3 ens4
  bond-mode balance-rr
  bond-miimon 100
  bond-downdelay 200
  bond-updelay 200
  dns-nameservers 8.8.8.8 8.8.4.4

EOF
```
