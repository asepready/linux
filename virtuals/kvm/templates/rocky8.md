# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/rocky8.qcow2 \
20G
```

# 2. Menjalankan image:

```sh
virt-install --name rocky8 \
  --virt-type kvm --memory 2048 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/rocky8.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/Rocky-8.9-x86_64-minimal.iso \
  --graphics spice \
  --os-type Linux --os-variant rocky8
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/rocky8.qcow2 -O qcow2 \
/home/$USER/kvm/rocky8gns3.qcow2
