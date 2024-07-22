# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/debian10.qcow2 \
10G
```

# 2. Menjalankan image:

```sh
virt-install --name debian10 \
  --virt-type kvm --memory 1024 --vcpus 2 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/debian10.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/debian-10.13.0-amd64-netinst.iso \
  --graphics spice \
  --os-type Linux --os-variant debian10
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/debian10.qcow2 -O qcow2 \
/home/$USER/kvm/debian10-cloud.qcow2
