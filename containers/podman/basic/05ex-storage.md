# Podman : Use External Storage

When a Container is removed, data in it are also lost, so it's necessary to use external storage on Containers if you'd like to save your data on Containers.

[1] It's possible to mount a directory on Docker Host into Containers.

```sh
# create a directory for containers data
[sysadmin@podman ~]$ mkdir /var/lib/containers/disk01
[sysadmin@podman ~]$ echo "persistent storage" >> /var/lib/containers/disk01/testfile.txt

# run a Container with mounting the directory above on [/mnt]
# if SELinux is [Enforcing], it needs to add [--privileged] option
[sysadmin@podman ~]$ podman run --privileged -it -v /var/lib/containers/disk01:/mnt rl8:latest /bin/bash
bash-5.2# df -hT /mnt
Filesystem Type Size Used Avail Use% Mounted on
/dev/mapper/rl-root xfs 71G 3.6G 68G 5% /mnt

bash-5.2# cat /mnt/testfile.txt
persistent storage
```

[2] It's also possible to configure external storage by Docker Data Volume command.

```sh
# create [volume01] volume
[sysadmin@podman ~]$ podman volume create volume01
volume01

# display volume list
[sysadmin@podman ~]$ podman volume ls
DRIVER VOLUME NAME
local volume01

# display details of [volume01]
[sysadmin@podman ~]$ podman volume inspect volume01
[
{
"Name": "volume01",
"Driver": "local",
"Mountpoint": "/var/lib/containers/storage/volumes/volume01/_data",
"CreatedAt": "2025-07-01T09:08:22.324141962+09:00",
"Labels": {},
"Scope": "local",
"Options": {},
"MountCount": 0,
"NeedsCopyUp": true,
"NeedsChown": true,
"LockNumber": 9
}
]

# run a container with mounting [volume01] to [/mnt] on container
[sysadmin@podman ~]$ podman run -it -v volume01:/mnt rl8:latest
bash-5.2# df -hT /mnt
Filesystem Type Size Used Avail Use% Mounted on
/dev/mapper/rl-root xfs 71G 3.6G 68G 5% /mnt

bash-5.2# echo "Podman Volume test" > /mnt/testfile.txt
bash-5.2# exit
[sysadmin@podman ~]$ cat /var/lib/containers/storage/volumes/volume01/\_data/testfile.txt
Podman Volume test

# possible to mount from other containers
[sysadmin@podman ~]$ podman run -v volume01:/var/volume01 rl8:latest /usr/bin/cat /var/volume01/testfile.txt
Podman Volume test

# to remove volumes, do like follows
[sysadmin@podman ~]$ podman volume rm volume01
Error: volume volume01 is being used by the following container(s): e8f4d7ee3886a38a50a89e5962c5ffe492d603f7b36e2d615eb147f1a1ee69f2, 7449fea0277971f75f1b57024e41ca982ec7c20100da42a7f1e10c32c9841e79: volume is being used

# if some containers are using the volume you'd like to remove like above,
# it needs to remove target containers before removing a volume
[sysadmin@podman ~]$ podman rm e8f4d7ee3886a38a50a89e5962c5ffe492d603f7b36e2d615eb147f1a1ee69f2
[sysadmin@podman ~]$ podman rm 7449fea0277971f75f1b57024e41ca982ec7c20100da42a7f1e10c32c9841e79
[sysadmin@podman ~]$ podman volume rm volume01
volume01

```
