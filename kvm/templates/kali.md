# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/kalilinux.qcow2 \
50G
```

# 2. Menjalankan image:

```sh
virt-install --name kali \
  --virt-type kvm --memory 2048 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/kalilinux.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/kali-linux-2024.2-installer-amd64.iso \
  --graphics spice \
  --os-type Linux --os-variant linux2022
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/kalilinux.qcow2 -O qcow2 \
/home/$USER/kvm/kl-linux.qcow2
