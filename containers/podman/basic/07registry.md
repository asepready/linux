# Podman : Use Registry

Install Registry to build Private Registry for Podman images.

Pull the Registry image and run it. Container images are located under [/var/lib/regstry] on Registry v2 Container,
so map to mount [$HOME/.local/share/containers/registry] on parent Host for Registry Container to use as Persistent Storage.

[1] Configure Registry.
This is for the case to use HTTP and no authentication.

```sh
[sysadmin@podman ~]$ podman pull quay.io/libpod/registry:2
[sysadmin@podman ~]$ mkdir $HOME/.local/share/containers/registry

# if SELinux is [Enforcing], add [--privileged] option
[sysadmin@podman ~]$ podman run --name registry --privileged -d -p 5000:5000 \
-v $HOME/.local/share/containers/registry:/var/lib/registry \
registry:2
[sysadmin@podman ~]$ podman ps
CONTAINER ID  IMAGE                                 COMMAND               CREATED         STATUS         PORTS                   NAMES
6251ea4359e7  quay.io/libpod/registry:2             /etc/docker/regis...  26 seconds ago  Up 26 seconds  0.0.0.0:5000->5000/tcp  registry

# if Firewalld is running, allow ports
[sysadmin@podman ~]$ firewall-cmd --add-port=5000/tcp
[sysadmin@podman ~]$ firewall-cmd --runtime-to-permanent

# verify to push to Registry from localhost
# for HTTP connection, add [--tls-verify=false] option
[sysadmin@podman ~]$ podman tag rl8 localhost:5000/rl8
[sysadmin@podman ~]$ podman push localhost:5000/rl8 --tls-verify=false
Getting image source signatures
Copying blob 9b179608d580 done |
Copying config 662115f822 done |
Writing manifest to image destination

[sysadmin@podman ~]$ podman images
REPOSITORY                     TAG         IMAGE ID      CREATED         SIZE
localhost/rl8-httpd            latest      fbbfe2391d52  17 minutes ago  582 MB
localhost:5000/rl8             latest      36ab69d52e1c  34 minutes ago  211 MB
localhost/rl8                  latest      36ab69d52e1c  34 minutes ago  211 MB
localhost/rl8-nginx            latest      cdd05264c534  46 minutes ago  382 MB
quay.io/rockylinux/rockylinux  latest      86f02aa837b3  3 years ago     211 MB
quay.io/libpod/registry        2           2d4f4b5309b1  5 years ago     26.8 MB
```

[2] To enable Basic authentication, Configure like follows.

```sh
[sysadmin@podman ~]$ dnf -y install httpd-tools
# add users for Registry authentication
[sysadmin@podman ~]$ htpasswd -Bc /etc/containers/.htpasswd rocky
New password:
Re-type new password:
Adding password for user rocky

[sysadmin@podman ~]$ podman run --name registry --privileged -d -p 5000:5000 \
-v .local/share/containers/registry:/var/lib/registry \
-v /etc/containers:/auth \
-e REGISTRY_AUTH=htpasswd \
-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/.htpasswd \
-e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
registry:2

# login as a user you added above
[sysadmin@podman ~]$ podman login localhost:5000 --tls-verify=false
Username: rocky
Password:
Login Succeeded!

[sysadmin@podman ~]$ podman tag rl8 localhost:5000/rl8
[sysadmin@podman ~]$ podman push localhost:5000/rl8 --tls-verify=false
[sysadmin@podman ~]$ podman images
REPOSITORY                     TAG         IMAGE ID      CREATED         SIZE
localhost/rl8-httpd            latest      fbbfe2391d52  17 minutes ago  582 MB
localhost:5000/rl8             latest      36ab69d52e1c  34 minutes ago  211 MB
localhost/rl8                  latest      36ab69d52e1c  34 minutes ago  211 MB
localhost/rl8-nginx            latest      cdd05264c534  46 minutes ago  382 MB
quay.io/rockylinux/rockylinux  latest      86f02aa837b3  3 years ago     211 MB
quay.io/libpod/registry        2           2d4f4b5309b1  5 years ago     26.8 MB
```

[3] This is for the case you set valid certificate like Let's Encrypt and enable HTTPS connection.
This example is based on that certificate were created under the [/etc/letsencrypt] directory.

```sh
[sysadmin@podman ~]$ podman run --name registry --privileged -d -p 5000:5000 \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/fullchain.pem \
-e REGISTRY_HTTP_TLS_KEY=/certs/privkey.pem \
-v /etc/letsencrypt/live/localhost:/certs \
-v .local/share/containers/registry:/var/lib/registry \
registry:2

# verify to push to Registry
[root@node01 ~]# podman tag rl8 localhost:5000/rl8
[root@node01 ~]# podman push localhost:5000/rl8
[root@node01 ~]# podman images
REPOSITORY                     TAG         IMAGE ID      CREATED         SIZE
localhost/rl8-httpd            latest      fbbfe2391d52  17 minutes ago  582 MB
localhost:5000/rl8             latest      36ab69d52e1c  34 minutes ago  211 MB
localhost/rl8                  latest      36ab69d52e1c  34 minutes ago  211 MB
localhost/rl8-nginx            latest      cdd05264c534  46 minutes ago  382 MB
quay.io/rockylinux/rockylinux  latest      86f02aa837b3  3 years ago     211 MB
quay.io/libpod/registry        2           2d4f4b5309b1  5 years ago     26.8 MB
```
