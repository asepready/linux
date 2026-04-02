# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/bsdrp.qcow2 \
2G
```

# 2. Menjalankan image:

```sh
virt-install --virt-type=kvm \
--name=bsdrp \
--vcpus=1 \
--memory=512 \
--cdrom=/home/$USER/kvm/BSDRP-1.99-full-amd64-vga.img \
--disk path=/home/$USER/kvm/bsdrp.qcow2,format=qcow2 \
--network default
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/BSDRP-1.95-full-amd64-serial.img -O qcow2 \
/home/$USER/kvm/bsd-router.qcow2
