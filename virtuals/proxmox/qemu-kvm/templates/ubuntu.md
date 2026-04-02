# 1. Persiapan buat Image Kosong:

```sh
qemu-img create -f qcow2 \
/home/$USER/KVMs/ubuntu20.qcow2 \
256G
```

# 2. Menjalankan image:

```sh
virt-install --name ubuntu20 \
  --virt-type kvm --memory 2048 --vcpus 2 \
  --boot hd,menu=on \
  --disk path=/home/$USER/KVMs/ubuntu20.qcow2,device=disk \
  --cdrom=/home/$USER/ISOs/ubuntu-20.04.6-live-server-amd64.iso \
  --graphics vnc \
  --os-type Linux --os-variant ubuntu20.04
```

# 3. Kompress File

```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/KVMs/ubuntu20.qcow2 -O qcow2 \
/home/$USER/KVMs/cl-ubuntu20.qcow2
```
