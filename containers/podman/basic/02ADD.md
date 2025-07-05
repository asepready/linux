# Podman : Add Container Images

Add new Container images you modified settings.
[1] For exmaple, update an official image with installing [httpd] and add it as a new Container image.

```sh
# show container images
[sysadmin@podman ~]$ podman images
REPOSITORY                     TAG         IMAGE ID      CREATED       SIZE
quay.io/rockylinux/rockylinux  latest      86f02aa837b3  3 years ago   211 MB

# run a container and install [httpd]
[sysadmin@podman ~]$ podman run rockylinux /bin/bash -c "dnf -y upgrade; dnf -y install httpd"
[sysadmin@podman ~]$ podman ps -a | tail -1
d9729660659a rockylinux /bin/bash -c dnf ... 22 seconds ago Exited (0) 2 seconds ago objective_villani

# add the image that [httpd] was installed
[sysadmin@podman ~]$ podman commit d9729660659a srv.world/rocky-httpd
Getting image source signatures
.....
.....
Writing manifest to image destination
Storing signatures
bb62279be7bdd4be75ac91988788d5413f76df22955c8eb277cfeceaf5497bd2

# show container images
[sysadmin@podman ~]$ podman images

REPOSITORY TAG IMAGE ID CREATED SIZE
srv.world/rocky-httpd latest bb62279be7bd 22 seconds ago 342 MB
docker.io/rockylinux/rockylinux latest 333da17614b6 5 weeks ago 234 MB

# confirm [httpd] to run a container

[sysadmin@podman ~]$ podman run srv.world/rocky-httpd /usr/bin/whereis httpd

httpd: /usr/sbin/httpd /usr/lib64/httpd /etc/httpd /usr/share/httpd /usr/share/man/man8/httpd.8.gz
```
