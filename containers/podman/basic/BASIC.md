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

# add the image that [httpd] was installed
podman commit d9729660659a localhost/rocky-httpd
```
