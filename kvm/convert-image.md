## Konversi file nama.ova ke nama.qcow2
Syaratnya untuk paket Debian :
```sh
sudo apt-get install qemu-utils
```
Syaratnya untuk paket RHEL :
```sh
sudo yum install qemu-img
```
Dan cek daftar format file dari paket qemu-img:
```sh
qemu-img -h | tail -n1
```
## Caranya
1. Ektrak arsip file nama.ova
  ```sh
  $ tar -xvf appliance.ova
  ```
  misal disini file gunakan template router merk MikroTik,
  [klik disini](https://download.mikrotik.com/routeros/7.3/chr-7.3.ova) untuk download file ovanya.

  Hasil extrak sebagai berikut:
  ```sh
  MikroTik_CHR_release_7.3.ovf #ovf file
  MikroTik_CHR_release_7.3.mf
  MikroTik_CHR_release_7.3-disk1.vmdk #Dsik Image File
  ```
2. File VDI/VMDK
Untuk vdi :
```sh
qemu-img convert -O qcow2 input.vdi output.qcow2
```
Untuk vmdk :
```sh
qemu-img convert -O qcow2 input.vmdk output.qcow2
```

```sh
qemu-img convert -f raw -O qcow2 BSDRP.img bsdrp.qcow2
qemu-system-x86_64 -m 512 \
-drive file=bsdrp.qcow2,index=0,media=disk,format=qcow2 \
-netdev user,id=net0 \
-device virtio-net,netdev=net0

3. Kompress File
#Compress the Image
qemu-img convert -c \
/home/$USER/kvm/debian7.qcow2 -O qcow2 \
/home/$USER/kvm/debian7-vm.qcow2
