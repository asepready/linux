Ubuntu Netplan
nano /etc/netplan/50-cloud-init.yaml

```sh
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
  bridges:
    br0:
      addresses: [ "172.22.97.21/20" ]
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
      routes:
        - to: default
          via: 172.22.97.1
          on-link: true
      interfaces:
        - eth0
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
