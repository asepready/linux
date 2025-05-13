# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/rocky9.qcow2 \
50G
```

# 2. Menjalankan image:

```sh
virt-install --name rocky9 \
  --virt-type kvm --memory 2048 --vcpus 2 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/rocky9.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/Rocky-9.5-x86_64-minimal.iso \
  --graphics vnc \
  --os-type Linux --os-variant rocky9
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/rocky9.qcow2 -O qcow2 \
/home/$USER/kvm/rl9.qcow2
