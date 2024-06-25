# Catataan Belajar Konfigurasi Dasar Alpine Linux

## 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/al3.16.qcow2 \
50G


virt-filesystems --long -h --all -a olddisk.qcow2
```

## 2. Menjalankan image:

```sh
virt-install --name alpinelinux3 \
  --virt-type kvm --memory 2048 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/al3.16.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/alpine-standard-3.19.1-x86_64.iso \
  --graphics spice \
  --os-type Linux --os-variant alpinelinux3.16
```

## 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/al3.16.qcow2 -O qcow2 \
/home/$USER/kvm/al3.16.init.qcow2

https://wiki.alpinelinux.org/wiki/Enable_Serial_Console_on_Boot