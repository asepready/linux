# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/parrotos.qcow2 \
16G
```

# 2. Menjalankan image:

```sh
virt-install --name parrotos \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/parrotos.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/Parrot-security-6.1_amd64.iso \
  --graphics spice \
  --os-type Linux --os-variant linux2022
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/parrotos.qcow2 -O qcow2 \
/home/$USER/kvm/parrot.qcow2
