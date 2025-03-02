Ubuntu Netplan
nano /etc/netplan/50-cloud-init.yaml
```sh 
network:
  version: 2
  ethernets:
    enp0s31f6:
      dhcp4: true
  bridges:
    br0:
      dhcp4: yes
      interfaces:
        - enp0s31f6
```

sudo netplan try

Create file kvm-hostbridge.xml
```sh
<network>
  <name>hostbridge</name>
  <forward mode="bridge"/>
  <bridge name="br0"/>
</network>
```

nano .config/kvm-hostbridge.xml
virsh net-define .config/kvm-hostbridge.xml
virsh net-start hostbridge
virsh net-autostart hostbridge
