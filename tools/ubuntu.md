# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/ubuntu22.qcow2 \
120G
```

# 2. Menjalankan image:

```sh
virt-install --name ubuntu22 \
  --virt-type kvm --memory 4096 --vcpus 4 \
  --boot hd,menu=on \
  --disk path=/home/$USER/kvm/ubuntu22.qcow2,device=disk \
  --cdrom=/home/$USER/kvm/ubuntu-24.04.2-live-server-amd64.iso \
  --graphics vnc \
  --os-type Linux --os-variant ubuntu22.04
```

# 3. Kompress File
```sh
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: false
      addresses:
        - 192.168.111.254/24
      gateway4: 192.168.111.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
        addresses: [1.1.1.1, 1.0.0.1]
        search: []

#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/ubuntu22.qcow2 -O qcow2 \
/home/$USER/kvm/wazuh.qcow2
