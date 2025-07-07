# Podman : Access to Services on Containers

If you'd like to access to services like HTTP or SSH that are running on Containers as daemons, Configure like follows.

[1] For example, use a Container that [httpd] is installed.

```sh
[sysadmin@podman ~]$ podman images
REPOSITORY                     TAG         IMAGE ID      CREATED        SIZE
localhost/rocky-httpd          latest      a376bf60ba05  6 minutes ago  582 MB
quay.io/rockylinux/rockylinux  latest      86f02aa837b3  3 years ago    211 MB

# run a container and also start [httpd]
# map with [-p xxx:xxx] to [(Host Port):(Container Port)]
[sysadmin@podman ~]$ podman run -dt --name httpd -p 8081:80 localhost/rocky-httpd /usr/sbin/httpd -D FOREGROUND
c5802244d5652697184cb1bb73cc0f2fcbd2857e9e3ee3736130ea5bd824253c

[sysadmin@podman ~]$ podman ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS
c5802244d565 localhost/rocky-httpd:latest /usr/sbin/httpd -... 10 seconds ago Up 11 seconds 0.0.0.0:8081->80/tcp cannon

# create a test page
[sysadmin@podman ~]$ podman exec c5802244d565 /bin/bash -c 'echo "httpd on Podman Container" > /var/www/html/index.html'

# if Firewalld is running, change setting
[sysadmin@podman ~]$ vi /etc/firewalld/firewalld.conf

# line 98 : change to [no]
StrictForwardPorts=no
[sysadmin@podman ~]$ systemctl restart firewalld

# verify accesses
[sysadmin@podman ~]$ curl localhost:8081
httpd on Podman Container

# also possible to access via container network
[sysadmin@podman ~]$ podman inspect -l | grep \"IPAddress
"IPAddress": "10.88.0.9",
"IPAddress": "10.88.0.9",

[sysadmin@podman ~]$ curl 10.88.0.9
httpd on Podman Container
```
