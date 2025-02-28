jika belum menginstall kvm harap di install terlebih dahulu. [Klik baca](https://www.how2shout.com/linux/how-to-install-and-configure-kvm-on-debian-11-bullseye-linux/) referensi install KVM

```sh
# Ubuntu
apt install qemu-kvm qemu-system qemu-utils libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon ovmf virt-manager guestfs-tools
# Fedora
sudo dnf groupinstall "Virtualization Host"
sudo dnf install qemu-kvm libvirt virt-install virt-manager
```

Pengizinan
```sh
sudo usermod -aG libvirt,kvm $USER
sudo systemctl restart libvirtd

#Polkit untuk Akses Tanpa Root
#/etc/polkit-1/rules.d/80-libvirt.rules
polkit.addRule(function(action, subject) {
    if (action.id == "org.libvirt.unix.manage" &&
        subject.isInGroup("libvirt")) {
            return polkit.Result.YES;
    }
});

sudo systemctl restart polkit

# Opsi Nonaktifkan Autentikasi Password untuk Libvirt
#/etc/libvirt/libvirtd.conf
unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"
auth_unix_rw = "none"

sudo systemctl restart libvirtd
```