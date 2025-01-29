jika belum menginstall kvm harap di install terlebih dahulu. [Klik baca](https://www.how2shout.com/linux/how-to-install-and-configure-kvm-on-debian-11-bullseye-linux/) referensi install KVM

```sh
apt install qemu-kvm qemu-system qemu-utils libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon ovmf
apt install virt-manager guestfs-tools
```


## Ubuntu 22.04 GPU passthrough (QEMU)

https://askubuntu.com/questions/1406888/ubuntu-22-04-gpu-passthrough-qemu