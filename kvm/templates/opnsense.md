# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/opn.qcow2 \
10G
```

# 2. Menjalankan image:

```sh
virt-install --name opnsense \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/opnsense.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/OPNsense-24.7-dvd-amd64.iso \
  --graphics spice \
  --os-type Linux --os-variant freebsd14.0
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/opnsense.qcow2 -O qcow2 \
/home/$USER/kvm/opnsense3.qcow2