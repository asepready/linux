```sh
dnf install qemu-kvm libvirt virt-manager virt-install
dnf install epel-release -y
dnf -y install bridge-utils virt-top libguestfs-tools virt-viewer

# Or Options
yum group install "Virtualization Tools" --setopt=group_package_types=mandatory,default,optional

systemctl start libvirtd
systemctl enable libvirtd
systemctl status libvirtd
usermod -aG libvirt $USER

sudo newgrp libvirt
brctl show

sudo nmcli connection show
sudo nmcli connection delete [name_or_UUID]
sudo nmcli connection add type bridge con-name br0 ifname br0
sudo nmcli connection add type bridge-slave ifname enp0s3 master br0
sudo nmcli connection modify br0 ipv4.method auto
sudo nmcli connection modify br0 ipv4.addresses [IP_address/subnet]
sudo nmcli connection modify br0 ipv4.gateway [gateway]
sudo nmcli connection modify br0 ipv4.dns 8.8.8.8 +ipv4.dns 1.1.1.1
sudo nmcli connection modify br0 ipv4.method manual
sudo nmcli connection up br0
sudo nmcli connection show br0
#bridge kvm
#/etc/qemu-kvm/bridge.conf
allow virbr0
allow all
sudo systemctl restart libvirtd
