# 1. Virtualization Packages Manually

- `qemu-kvm`: This package provides the user-level KVM emulator and facilitates communication between hosts and guest virtual machines.
- `qemu-img`: This package provides disk management for guest virtual machines.
- `libvirt`: This package provides the server and host-side libraries for interacting with hypervisors and host systems, and the libvirtd daemon that handles the library calls, manages virtual machines, and controls the hypervisor.

# 2. Additional virtualization management packages

- `virt-manager`: This package provides the virt-manager tool, also known as Virtual Machine Manager. This is a graphical tool for administering virtual machines. It uses the libvirt-client library as the management API.

```sh
dnf install epel-release -y
# Virtualization Packages
dnf install qemu-kvm qemu-img libvirt
# Additional virtualization management
dnf install virt-manager

sudo systemctl enable libvirtd

sudo usermod -aG libvirt $USER

sudo systemctl start libvirtd; sudo systemctl status libvirtd

sudo chown -R $USER:libvirt /var/lib/libvirt/

# Additional Bridge
dnf install bridge-utils
export MAIN_CONN=enp3s4f0
bash -x <<EOS
systemctl stop libvirtd
nmcli c delete "$MAIN_CONN"
nmcli c delete "Wired connection 1"
nmcli c add type bridge ifname br0 autoconnect yes con-name br0 stp off
nmcli c modify br0 ipv4.addresses 192.168.111.6/24 ipv4.method manual
nmcli c modify br0 ipv4.gateway 192.168.111.1
nmcli c modify br0 ipv4.dns 8.8.8.8 + ipv4.dns 8.8.4.4
nmcli c add type bridge-slave autoconnect yes con-name "$MAIN_CONN" ifname "$MAIN_CONN" master br0
systemctl restart NetworkManager
systemctl start libvirtd
systemctl enable libvirtd
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-ipforward.conf
echo "net.bridge.bridge-nf-call-ip6tables = 0 | sudo tee /etc/sysctl.d/99-ipforward.conf
echo "net.bridge.bridge-nf-call-iptables = 0 | sudo tee /etc/sysctl.d/99-ipforward.conf
echo "net.bridge.bridge-nf-call-arptables = 0 | sudo tee /etc/sysctl.d/99-ipforward.conf
sysctl -p /etc/sysctl.d/99-ipforward.conf
EOS

#bridge kvm
#/etc/qemu-kvm/bridge.conf
allow virbr0
allow all
```
