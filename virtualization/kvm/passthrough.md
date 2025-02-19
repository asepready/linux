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