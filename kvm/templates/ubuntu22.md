# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/ubuntu22.qcow2 \
20G
```

# 2. Menjalankan image:

```sh
virt-install --name ubuntu22 \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/ubuntu22.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/ubuntu-22.04.3-live-server-amd64.iso \
  --graphics spice \
  --os-type Linux --os-variant ubuntu22.04
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/ubuntu22.qcow2 -O qcow2 \
/home/$USER/kvm/ubuntu22gns3.qcow2
