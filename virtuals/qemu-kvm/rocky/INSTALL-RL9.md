# 1. Virtualization Packages Manually

- `qemu-kvm`: This package provides the user-level KVM emulator and facilitates communication between hosts and guest virtual machines.
- `qemu-img`: This package provides disk management for guest virtual machines.
- `libvirt`: This package provides the server and host-side libraries for interacting with hypervisors and host systems, and the libvirtd daemon that handles the library calls, manages virtual machines, and controls the hypervisor.

# 2. Additional virtualization management packages

- `virt-manager`: This package provides the virt-manager tool, also known as Virtual Machine Manager. This is a graphical tool for administering virtual machines. It uses the libvirt-client library as the management API.

```sh
dnf install epel-release -y
# Virtualization Packages
sudo dnf install qemu-kvm qemu-img libvirt
# Additional virtualization management
sudo dnf install virt-manager virt-viewer

sudo systemctl enable libvirtd

sudo usermod -aG libvirt,kvm,qemu $USER

sudo systemctl start libvirtd; sudo systemctl status libvirtd

sudo chown -R $USER:libvirt /var/lib/libvirt/

# Additional Bridge
sudo dnf install bridge-utils

export MAIN_CONN=enp3s4f0
bash -x <<EOS
echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=0" | sudo tee /etc/sysctl.d/99-sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=0" | sudo tee /etc/sysctl.d/99-sysctl.conf
echo "net.bridge.bridge-nf-call-arptables=0" | sudo tee /etc/sysctl.d/99-sysctl.conf
echo "kernel.unprivileged_userns_clone=1" | sudo tee /etc/sysctl.d/99-sysctl.conf
echo "net.ipv4.ip_unprivileged_port_start=22" | sudo tee /etc/sysctl.d/99-sysctl.conf
echo "fs.file-max=65536" | sudo tee /etc/sysctl.d/99-sysctl.conf
echo "vm.max_map_count=262144" | sudo tee /etc/sysctl.d/99-sysctl.conf
sysctl -p /etc/sysctl.d/99-sysctl.conf
systemctl stop libvirtd
nmcli c delete "$MAIN_CONN"
nmcli c delete "Wired connection 0"
nmcli c add type bridge ifname br0 autoconnect yes con-name br0 stp off
nmcli c modify br0 ipv4.addresses 192.168.111.6/24 ipv4.method manual
nmcli c modify br0 ipv4.gateway 192.168.111.1
nmcli c modify br0 ipv4.dns 8.8.8.8 + ipv4.dns 8.8.4.4
nmcli c add type bridge-slave autoconnect yes con-name "$MAIN_CONN" ifname "$MAIN_CONN" master br0
systemctl restart NetworkManager
systemctl start libvirtd
systemctl enable libvirtd
EOS

export MAIN_CONN=enp3s4f1
bash -x <<EOS
systemctl stop libvirtd
nmcli c delete "$MAIN_CONN"
nmcli c delete "Wired connection 1"
nmcli c add type bridge ifname br1 autoconnect yes con-name br1 stp off
nmcli c modify br1 ipv4.addresses 192.168.10.254/24 ipv4.method manual
nmcli c add type bridge-slave autoconnect yes con-name "$MAIN_CONN" ifname "$MAIN_CONN" master br1
systemctl restart NetworkManager
systemctl start libvirtd
EOS

#bridge kvm
#/etc/qemu-kvm/bridge.conf
allow virbr0
allow all
```
