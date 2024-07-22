# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/almalinux8.qcow2 \
50G
```

# 2. Menjalankan image:

```sh
virt-install --name almalinux8 \
  --virt-type kvm --memory 2048 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/almalinux8.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/AlmaLinux-8.8-x86_64-boot.iso \
  --graphics spice \
  --os-type Linux --os-variant almalinux8
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/almalinux8.qcow2 -O qcow2 \
/home/$USER/kvm/almalinux.qcow2
