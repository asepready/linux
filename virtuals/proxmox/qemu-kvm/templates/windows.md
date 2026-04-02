# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/win7.qcow2 \
32G
```

# 2. Menjalankan image:

```sh
virt-install --name win7 \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/win7.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/Win7_Pro_SP1_English_x64.iso \
  --graphics spice \
  --os-type Linux --os-variant win7
```

# 3. Kompress File
```sh
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/win7.qcow2 -O qcow2 \
/home/$USER/kvm/win7gns3.qcow2