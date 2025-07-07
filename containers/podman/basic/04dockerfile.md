# Podman : Use Dockerfile

Use Dockerfile and create Container images automatically.
It is also useful for configuration management for Container images.

[1] For example, Create a Dockerfile that Nginx is installed and started.

```sh
[root@dlp ~]# vi Dockerfile

# create new

FROM docker.io/rockylinux/rockylinux:10.0-ubi
LABEL Maintainer "ServerWorld <admin@srv.world>"

RUN dnf -y install nginx
RUN echo "Dockerfile Test on Nginx" > /usr/share/nginx/html/index.html

EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# build image ⇒ podman build -t [image name]:[tag] .

[root@dlp ~]# podman build -t srv.world/rocky-nginx:latest .
STEP 1/6: FROM docker.io/rockylinux/rockylinux:10.0-ubi
STEP 2/6: LABEL Maintainer "ServerWorld <admin@srv.world>"
--> 31dacb599cc1
STEP 3/6: RUN dnf -y install nginx

.....
.....

STEP 6/6: CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
COMMIT srv.world/rocky-nginx:latest
--> 03ab068245ee
Successfully tagged srv.world/rocky-nginx:latest
03ab068245eeb8777d015f497ee1ec166340ee055a07eb76ed4e92aeb4f8cb74

[root@dlp ~]# podman images
REPOSITORY TAG IMAGE ID CREATED SIZE
srv.world/rocky-nginx latest 03ab068245ee 53 seconds ago 295 MB
srv.world/rocky-httpd latest 6901e50a71f9 9 minutes ago 342 MB
docker.io/rockylinux/rockylinux 10.0-ubi 662115f822fb 3 weeks ago 264 MB

# run container

[root@dlp ~]# podman run -d -p 80:80 srv.world/rocky-nginx
54263eff1f69c094066869c9d1f02df708a88995101d168a125c772ab1276912

[root@dlp ~]# podman ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
54263eff1f69 srv.world/rocky-nginx:latest /usr/sbin/nginx -... 20 seconds ago Up 20 seconds 0.0.0.0:80->80/tcp amazing_swartz

# if Firewalld is running, change setting

[root@dlp ~]# vi /etc/firewalld/firewalld.conf

# line 98 : change to [no]

StrictForwardPorts=no
[root@dlp ~]# systemctl restart firewalld

# verify accesses

[root@dlp ~]# curl localhost
Dockerfile Test on Nginx

# also possible to access via container network

[root@dlp ~]# podman inspect -l | grep \"IPAddress
"IPAddress": "10.88.0.12",
"IPAddress": "10.88.0.12",

[root@dlp ~]# curl 10.88.0.12
Dockerfile Test on Nginx
```

The format of Dockerfile is [INSTRUCTION arguments].
Refer to the following description for INSTRUCTION.
<image src="../assets/Dockerfile.png"/>
