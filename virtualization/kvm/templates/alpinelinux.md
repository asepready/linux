# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/alpinelinux3.qcow2 \
32G
```

# 2. Menjalankan image:

```sh
virt-install --name alpinelinux3 \
  --virt-type kvm --memory 2048 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/alpinelinux3.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/alpine-virt-3.20.3-x86.iso \
  --graphics spice \
  --os-type Linux --os-variant alpinelinux3.17
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/alpinelinux3.qcow2 -O qcow2 \
/home/$USER/kvm/alpinelinux.qcow2


https://wiki.alpinelinux.org/wiki/Enable_Serial_Console_on_Boot
