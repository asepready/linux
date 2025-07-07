# Podman : Use Docker Command

Install a script named [docker] that emulates the Docker CLI by executes podman commands.

[1] Install Podman-docker package.

```sh
[sysadmin@podman ~]$ dnf -y install podman-docker

# [docker] command is installed

[sysadmin@podman ~]$ ll /usr/bin/docker
-rwxr-xr-x. 1 root root 232 Jun 4 09:00 /usr/bin/docker

# emulates the Docker CLI by executes podman

[sysadmin@podman ~]$ cat /usr/bin/docker
#!/usr/bin/sh
[ -e /etc/containers/nodocker ] || [ -e "\${XDG_CONFIG_HOME-\/builddir/.config}/containers/nodocker" ] || \
echo "Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg." >&2
exec /usr/bin/podman "$@"

# test [docker] command
[sysadmin@podman ~]$ docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                     TAG         IMAGE ID      CREATED         SIZE
localhost/iproute              latest      00c630e23081  33 minutes ago  313 MB
localhost/rl8-httpd            latest      fbbfe2391d52  2 hours ago     582 MB
localhost:5000/rl8             latest      36ab69d52e1c  3 hours ago     211 MB
localhost/rl8                  latest      36ab69d52e1c  3 hours ago     211 MB
localhost/rl8-nginx            latest      cdd05264c534  3 hours ago     382 MB
quay.io/rockylinux/rockylinux  latest      86f02aa837b3  3 years ago     211 MB
quay.io/libpod/registry        2           2d4f4b5309b1  5 years ago     26.8 MB
```
