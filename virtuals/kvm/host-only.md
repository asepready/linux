Buat File
```sh
#tmp/host-only.xml
<network>
  <name>host-only</name>
  <forward mode="none"/>
  <bridge name="virbr1" stp="on" delay="0"/>
  <ip address="192.168.100.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.100.100" end="192.168.100.200"/>
    </dhcp>
  </ip>
</network>
```

```sh
#Add Adapter
sudo virsh net-define /tmp/host-only.xml
sudo virsh net-start host-only
sudo virsh net-autostart host-only
sudo virsh net-list --all

# Remove Adapter
sudo virsh net-destroy host-only
sudo virsh net-undefine host-only
```
