```sh
# download the official image
podman pull quay.io/rockylinux/rockylinux

# create container
podman run rockylinux /bin/echo "Welcome to the Podman World"

# Connect to the interactive session of a Container
podman run -it rockylinux /bin/bash

# stop container
podman stop rockylinux

# show container process
podman ps

# run a container and install [httpd]
podman run rockylinux /bin/bash -c "dnf -y upgrade; dnf -y install httpd"
podman ps -a | tail -1
bdd8363fb9ec  quay.io/rockylinux/rockylinux:latest /bin/bash -c dnf ...  11 minutes ago  Exited (0) 9 minutes ago                 focused_noyce

# add the image that [httpd] was installed
podman commit bdd8363fb9ec localhost/rocky-httpd

# confirm [httpd] to run a container
podman run localhost/rocky-httpd /usr/bin/whereis httpd

# run a container and also start [httpd]
# map with [-p xxx:xxx] to [(Host Port):(Container Port)]
podman run -dt --name httpd -p 8081:80 localhost/rocky-httpd /usr/sbin/apachectl -D FOREGROUND
```
