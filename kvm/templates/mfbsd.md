# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/mfbsd.qcow2 \
50G
```

# 2. Menjalankan image:

```sh
virt-install --name mfbsd \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/mfbsd.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/mfsbsd-mini-14.1-RELEASE-amd64.iso \
  --graphics spice \
  --os-type FreeBSD --os-variant freebsd14.0
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/mfbsd.qcow2 -O qcow2 \
/home/$USER/kvm/fbsd14.qcow2