# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/ubuntu16.qcow2 \
50G
```

# 2. Menjalankan image:

```sh
virt-install --name ubuntu16 \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/ubuntu16.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/ubuntu-16.04.7-server-amd64.iso \
  --graphics spice \
  --os-type Linux --os-variant ubuntu16.04
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/ubuntu16.qcow2 -O qcow2 \
/home/$USER/kvm/ubuntu16gns3.qcow2
