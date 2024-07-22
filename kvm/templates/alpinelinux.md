# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/alpinelinux3.qcow2 \
16G
```

# 2. Menjalankan image:

```sh
virt-install --name alpinelinux3 \
  --virt-type kvm --memory 2048 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/alpinelinux3.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/alpine-virt-3.15.9-x86_64.iso \
  --graphics spice \
  --os-type Linux --os-variant alpinelinux3.17
```

# 3. Kompress File
```sh
#Compress the Image
t

https://wiki.alpinelinux.org/wiki/Enable_Serial_Console_on_Boot
