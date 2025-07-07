# Podman : Podman Network

This is the basic usage to configure Podman Network.

[1] When running containers without specifying network, default [podman] network is assigned.

```sh
# display network list

[sysadmin@podman ~]$ podman network ls
NETWORK ID NAME DRIVER
2f259bab93aa podman bridge

# display details of [podman]
[sysadmin@podman ~]$ podman network inspect podman
[
{
"name": "podman",
"id": "2f259bab93aaaaa2542ba43ef33eb990d0999ee1b9924b557b7be53c0b7a1bb9",
"driver": "bridge",
"network_interface": "podman0",
"created": "2025-07-01T09:25:15.098111741+09:00",
"subnets": [
{
"subnet": "10.88.0.0/16",
"gateway": "10.88.0.1"
}
],
"ipv6_enabled": false,
"internal": false,
"dns_enabled": false,
"ipam_options": {
"driver": "host-local"
},
"containers": {}
}
]

# [podman] is assigned as container network by default
[sysadmin@podman ~]$ podman run --name rl8 /bin/bash -c "dnf -y install iproute; /usr/sbin/ip route" rl8
.....
.....
default via 10.88.0.1 dev eth0 proto static metric 100
10.88.0.0/16 dev eth0 proto kernel scope link src 10.88.0.19

[sysadmin@podman ~]$ podman commit $(podman ps -a | tail -1 | awk '{print $1}') localhost/iproute
```

[2] If you'd like to assign another network, configure like follows.

```sh
# create network [macvlan] with [172.16.0.0/24] subnet
[sysadmin@podman ~]$ podman network create --subnet 172.16.0.0/24 macvlan
[sysadmin@podman ~]$ podman network ls
NETWORK ID    NAME        DRIVER
3be8e6cf5f51  macvlan     bridge
2f259bab93aa  podman      bridge

# run a container with specifying [macvlan]
[sysadmin@podman ~]$ podman run --network macvlan localhost/iproute /usr/sbin/ip route
default via 172.16.0.1 dev eth0 proto static metric 100
172.16.0.0/24 dev eth0 proto kernel scope link src 172.16.0.2

# to attach the network to existing running container, set like follows
[sysadmin@podman ~]$ podman run -td --name nginx --network macvlan -p 80:80 rl8-nginx
[sysadmin@podman ~]$ podman ps
STATUS         PORTS                   NAMES
f35d5303ba27  localhost/rl8-nginx:latest  /usr/sbin/nginx -...  16 seconds ago  Up 16 seconds  0.0.0.0:80->80/tcp      nginx

[sysadmin@podman ~]$ podman exec f35d5303ba27 /bin/bash -c "/usr/sbin/ip route"
default via 172.16.0.1 dev eth0 proto static metric 100
172.16.0.0/24 dev eth0 proto kernel scope link src 172.16.0.4

# attach network to specify an IP address in the subnet
[sysadmin@podman ~]$ podman network connect podman f35d5303ba27
[sysadmin@podman ~]$ podman exec f35d5303ba27 ip route
default via 10.88.0.1 dev eth1 proto static metric 100
default via 172.16.0.1 dev eth0 proto static metric 100
10.88.0.0/16 dev eth1 proto kernel scope link src 10.88.0.2
172.16.0.0/24 dev eth0 proto kernel scope link src 172.16.0.4

# to disconnect the network, set like follows
[sysadmin@podman ~]$ podman network disconnect podman f35d5303ba27
[sysadmin@podman ~]$ podman exec f35d5303ba27 ip route
default via 172.16.0.1 dev eth0 proto static metric 100
172.16.0.0/24 dev eth0 proto kernel scope link src 172.16.0.4
```

[3] To remove podman networks, set like follows.

```sh
[sysadmin@podman ~]$ podman network ls
NETWORK ID NAME DRIVER
320b73921286 macvlan bridge
2f259bab93aa podman bridge

# remove [macvlan]

[sysadmin@podman ~]$ podman network rm macvlan
Error: "macvlan" has associated containers with it. Use -f to forcibly delete containers and pods: network is being used

# force remove containers with [-f] option
[sysadmin@podman ~]$ podman network rm -f macvlan
macvlan

```
