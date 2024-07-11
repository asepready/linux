Docker in LXC

Creating the Container

Firstly you need to download the Alpine container template.
```sh
pveam update
pveam available | grep alpine

pveam download local alpine-3.15-default_20211202_amd64.tar.xz
```
After the download is finished, create the container:
```sh
pct create 123 local:vztmpl/alpine-3.15-default_20211202_amd64.tar.xz --unprivileged 1 -features nesting=1 --net0 name=eth0,bridge=vmbr0,firewall=1,gw=20.122.0.2,ip=20.122.0.9/24,type=veth --storage local-lvm

```
After container is created, you need to edit the configuration file to add the /dev/net/tun device.
```sh
pct config 123
```
```sh output
 arch: amd64
 hostname: CT123
 memory: 512
 net0: name=eth0,bridge=vmbr0,firewall=1,hwaddr=FE:75:64:2A:A3:58,ip=dhcp,type=veth
 ostype: debian
 rootfs: local-lvm:vm-123-disk-0,size=4G
 features: nesting=1
 swap: 512
 unprivileged: 1

nano /etc/pve/lxc/123.conf
```
Add the following lines at the end (if you're using PVE < 7.0, change `cgroup2` with `cgroup`)
```sh
 lxc.cgroup2.devices.allow: c 10:200 rwm
 lxc.mount.entry: /dev/net dev/net none bind,create=dir
```
Press Ctrl-X and answer "Y" for saving and press Enter.

For your unprivileged container to be able to access the /dev/net/tun from your host, you need to set the owner by running:
```sh
chown 100000:100000 /dev/net/tun
```
Check the permissions are set correctly:
```sh
ls -l /dev/net/tun
 
 crw-rw-rw- 1 100000 100000 10, 200 Dec 22 13:26 /dev/net/tun
```
Finally start the container:
```sh
pct start 123
```
If you did everything correctly then the container should start.
Using OpenVPN

Enter the container:
```sh
pct enter 123
```
You should now see the container shell prompt.
```sh
root@CT123:~# ls -l /dev/net/tun
 crw-rw-rw- 1 root root 10, 200 Dec 22 12:26 /dev/net/tun
```
If you see root:root inside the container and 100000:100000 outside the container, it's correct. (This is because the unprivileged userid 100000 on your host is mapped to 'root' user of the container)

Update packages and install openvpn:
```sh
 root@CT123:~# apt update
 root@CT123:~# apt dist-upgrade
 root@CT123:~# apt install openvpn git
```
You can use this repository for a basic configuration: https://github.com/Nyr/openvpn-install
```sh
 root@CT123:~# git clone https://github.com/Nyr/openvpn-install
 root@CT123:~# cd openvpn-install
 root@CT123:~# bash openvpn-install.sh
```
Answer the setup wizard questions according to your setup. At the end you should receive a message like this:

 Finished!
 The client configuration is available in: /root/client.ovpn
 New clients can be added by running this script again.

If everything worked, then the service should be started and enabled by the setup script.

Verify service is working:
```sh
 root@CT123:~# systemctl | grep openvpn
 openvpn-iptables.service             loaded active exited    openvpn-iptables.service                             
 openvpn-server@server.service        loaded active running   OpenVPN service for server                           
 system-openvpn\x2dserver.slice       loaded active active    system-openvpn\x2dserver.slice
 root@CT123:~# ps aux | grep vpn
 nobody     136  0.0  1.3  11780  6844 ?        Ss   14:41   0:00 /usr/sbin/openvpn --status /run/openvpn-server/status-server.log --status-version 2 --suppress-timestamps --config server.conf
```
Congratulations! You now have an unprivileged Debian container running OpenVPN! 