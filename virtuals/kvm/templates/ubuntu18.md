# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/ubuntu18.qcow2 \
150G
```

# 2. Menjalankan image:

```sh
virt-install --name ubuntu18 \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/ubuntu18.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/ubuntu-18.04.6-live-server-amd64.iso \
  --graphics vnc \
  --os-type Linux --os-variant ubuntu18.04
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/ubuntu18.qcow2 -O qcow2 \
/home/$USER/kvm/ubu18.qcow2
