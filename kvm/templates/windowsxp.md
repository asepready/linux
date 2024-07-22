# 1. Persiapan buat Image Kosong:
```sh
qemu-img create -f qcow2 \
/home/sava/GNS3/images/QEMU/winxp.qcow2 \
4G
```

# 2. Menjalankan image:

```sh
virt-install --virt-type=kvm \
--name=winxp \
--vcpus=1 \
--memory=512 \
--cdrom=/home/sava/GNS3/images/winxp.iso \
--disk path=/home/sava/GNS3/images/QEMU/winxp.qcow2,format=qcow2 \
--network default
--graphics yes
```
