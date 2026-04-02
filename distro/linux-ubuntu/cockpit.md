Cockpit comes installed by default in Server.

```sh
# Debian
. /etc/os-release
echo "deb http://deb.debian.org/debian ${VERSION_CODENAME}-backports main" > \
    /etc/apt/sources.list.d/backports.list
apt update
Install or update the package:
apt install -t ${VERSION_CODENAME}-backports cockpit


apt install qemu-kvm libvirt-daemon libvirt-clients bridge-utils

systemctl enable --now libvirtd
sudo apt install cockpit-machines cockpit-podman

# /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp1s0
iface enp1s0 inet manual


auto br0
iface br0 inet static
    bridge_ports enp1s0
    bridge_stp off
    address 192.168.122.200
    network 192.168.122.0
    netmask 255.255.255.0
    broadcast 192.168.122.255
    gateway 192.168.122.1
    dns-nameservers 8.8.8.8 1.1.1.1

