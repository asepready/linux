# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/centos7.qcow2 \
50G
```

# 2. Menjalankan image:

```sh
virt-install --name centos7 \
  --virt-type kvm --memory 512 --vcpus 1 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/centos7.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/CentOS-7-x86_64-Minimal-2009.iso \
  --graphics spice \
  --os-type Linux --os-variant centos7
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/centos7.qcow2 -O qcow2 \
/home/$USER/kvm/nagios.qcow2
