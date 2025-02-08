jika belum menginstall kvm harap di install terlebih dahulu. [Klik baca](https://www.how2shout.com/linux/how-to-install-and-configure-kvm-on-debian-11-bullseye-linux/) referensi install KVM

```sh
apt install qemu-kvm qemu-system qemu-utils libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon ovmf
apt install virt-manager guestfs-tools
```


## Ubuntu 22.04 GPU passthrough (QEMU)

https://askubuntu.com/questions/1406888/ubuntu-22-04-gpu-passthrough-qemu

Create a new file called vfio.conf
Add the following lines with your device IDs from the:

```sh
sudo nano /etc/modprobe.d/vfio.conf

#/etc/modprobe.d/vfio.conf
blacklist nouveau
blacklist snd_hda_intel
options vfio-pci ids=10aa:10bb,01cc:01ee
```

Edit the guest machine
```sh
$ virsh list --all
$ sudo virsh edit YourGuestMachineName
```

Add the following lines:
```sh
<vendor_id state='on' value='1234567890ab'/>
<kvm>
 <hidden state='on'/>
</kvm>
<ioapic driver='kvm'/>
```

The end result should look something like:
```sh
  <features>
    <acpi/>
    <apic/>
    <hyperv>
      <relaxed state='on'/>
      <vapic state='on'/>
      <spinlocks state='on' retries='8191'/>
      <vendor_id state='on' value='1234567890ab'/>
    </hyperv>
    <kvm>
      <hidden state='on'/>
    </kvm>
    <vmport state='off'/>
    <ioapic driver='kvm'/>
  </features>
```