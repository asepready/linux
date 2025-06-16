# Moving rootless storage

Podman uses two storage locations, depending on the mode you’re using.

In rootful mode, all containers and container-related storage is in `/var/lib/containers/storage`. In rootless mode, this changes to the users home directory: `/home/<user>/.local/share/containers/storage`.

```sh
sudo mkdir -p /var/lib/containers/user/podman/storage
sudo chmod 0711 /var/lib/containers /var/lib/containers/user
sudo chmod -R 0700 /var/lib/containers/user/podman
sudo chown -R podman:podman /var/lib/containers/user/podman

```

## SeLinux on RHEL/Rocky

Checking /etc/selinux/targeted/contexts/files/file_contexts, I found out which additional selinux contexts I had to add to the newly created directories:

```sh
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2-images(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2-layers(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay-layers(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay-images(/.*)?'
sudo semanage fcontext --add --type container_file_t    '/var/lib/containers/user/[^/]+/storage/volumes/[^/]*/.*'

```
