# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/debian8.qcow2 \
32G
```

# 2. Menjalankan image:

```sh
virt-install --name debian8 \
  --virt-type kvm --memory 2048 --vcpus 2 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/debian8.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/debian-8.11.1-amd64-DVD-1.iso \
  --graphics spice \
  --os-type Linux --os-variant debian8
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/debian8.qcow2 -O qcow2 \
/home/$USER/kvm/debian.qcow2
