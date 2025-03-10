```sh
dnf install epel-release -y
dnf install qemu-kvm libvirt virt-manager virt-install virt-top libguestfs-tools virt-viewer
dnf -y install bridge-utils  

# Or Options
yum group install "Virtualization Tools" --setopt=group_package_types=mandatory,default,optional

systemctl start libvirtd
systemctl enable libvirtd
systemctl status libvirtd
sudo usermod -aG kvm,libvirt,libvirtdbus,qemu,kvm $USER
sudo chown -R $USER:libvirt /var/lib/libvirt/

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