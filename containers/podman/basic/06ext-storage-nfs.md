# Podman : Use External Storage (NFS)

This is an example to use NFS External Storage.

[1] NFS server is required to be running on your LAN, refer to here.
On this example, configure [/home/nfsshare] directory on [nfs.localhost] as a shared directory.

[2] Create a volume for NFS and use it.

```sh
# create [nfs-volume] volume
[sysadmin@podman ~]$ podman volume create \
--opt type=nfs4 \
--opt o=rw \
--opt device=10.0.0.35:/home/nfsshare nfs-volume
nfs-volume

# display volume list
[sysadmin@podman ~]$ podman volume ls
DRIVER VOLUME NAME
local nfs-volume

# display details of [nfs-volume]

[sysadmin@podman ~]$ podman volume inspect nfs-volume
[
{
"Name": "nfs-volume",
"Driver": "local",
"Mountpoint": "/var/lib/containers/storage/volumes/nfs-volume/_data",
"CreatedAt": "2025-07-01T09:14:57.026127375+09:00",
"Labels": {},
"Scope": "local",
"Options": {
"device": "10.0.0.35:/home/nfsshare",
"o": "rw",
"type": "nfs4"
},
"MountCount": 0,
"NeedsCopyUp": true,
"NeedsChown": true,
"LockNumber": 9
}
]

# run container with mounting [nfs-volume] to [/nfsshare] on container
[sysadmin@podman ~]$ podman run -it -v nfs-volume:/nfsshare rl8:latest

# verify
bash-5.2# df -hT /nfsshare
Filesystem Type Size Used Avail Use% Mounted on
10.0.0.35:/home/nfsshare nfs4 157G 0 149G 0% /nfsshare

bash-5.2# echo "Podman NFS Volume Test" > /nfsshare/testfile.txt
bash-5.2# cat /nfsshare/testfile.txt
Podman NFS Volume Test
```
