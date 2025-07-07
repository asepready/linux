# Podman : Use Docker Compose

To Install Docker Compose, it's easy to configure and run multiple containers as a Docker application.

[1] Install [Podman-docker](./09docker-cli.md), refer to here.

[2] Install Docker Compose.

```sh
[sysadmin@podman ~]# curl -L https://github.com/docker/compose/releases/download/v2.38.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
[sysadmin@podman ~]# chmod 755 /usr/local/bin/docker-compose
[sysadmin@podman ~]$ docker-compose --version
Docker Compose version v2.38.1
```

[3] For example, Configure an application that has Web and DB services with Docker Compose.

```sh
# start podman.socket

[sysadmin@podman ~]$ systemctl start podman.socket

# define Web service container

[sysadmin@podman ~]$ vi Dockerfile
FROM quay.io/rockylinux/rockylinux
LABEL Maintainer "AsepReady <admin@localhost>"

RUN dnf -y install nginx
RUN echo "Dockerfile Test on Nginx" > /usr/share/nginx/html/index.html

EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# define application configuration
[sysadmin@podman ~]$ vi docker-compose.yml
services:
  db:
    image: quay.io/centos7/mariadb-103-centos7
    volumes: - /var/lib/containers/disk01:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_USER: rocky
      MYSQL_PASSWORD: password
      MYSQL_DATABASE: rocky_db
    user: 0:0
    privileged: true
    ports: - "3306:3306"
  web:
    build: .
    ports: - "80:80"
    volumes: - /var/lib/containers/disk02:/usr/share/nginx/html
    privileged: true

# build and run

[sysadmin@podman ~]$ docker-compose up -d
[+] Running 10/10

.....
.....

[+] Running 3/3veth2: entered allmulticast mode
✓ web Built
✓ Container root-db-1 Started
✓ Container root-web-1 Started

[sysadmin@podman ~]$ podman ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
e4802fd33c9b docker.io/moby/buildkit:buildx-stable-1 About a minute ago Up About a minute buildx_buildkit_default
ec08b518c2e6 quay.io/rockylinux/rockylinux /usr/sbin/nginx -... 25 seconds ago Up 25 seconds 0.0.0.0:80->80/tcp root-web-1
1f98c777866a docker.io/library/mariadb:latest mariadbd 25 seconds ago Up 25 seconds 0.0.0.0:3306->3306/tcp root-db-1

# verify accesses

[sysadmin@podman ~]$ mysql -h 127.0.0.1 -u root -p -e "show variables like 'hostname';"
Enter password:
+---------------+--------------+
| Variable_name | Value |
+---------------+--------------+
| hostname | 1f98c777866a |
+---------------+--------------+

[sysadmin@podman ~]$ mysql -h 127.0.0.1 -u rocky -p -e "show databases;"
Enter password:
+--------------------+
| Database |
+--------------------+
| rocky_db |
| information_schema |
+--------------------+

[sysadmin@podman ~]$ echo "Hello Docker Compose World" > /var/lib/containers/disk02/index.html
[sysadmin@podman ~]$ curl 127.0.0.1
Hello Docker Compose World
[4] Other basic operations of Docker Compose are follows.

# verify state of containers

[sysadmin@podman ~]$ docker-compose ps
NAME IMAGE COMMAND SERVICE CREATED STATUS PORTS
root-db-1 docker.io/library/mariadb:latest "mariadbd" db 2 minutes ago Up 2 minutes 3306/tcp
root-web-1 docker.io/library/root-web:latest "/usr/sbin/nginx -g …" web 2 minutes ago Up 2 minutes 80/tcp

# show logs of containers

[sysadmin@podman ~]$ docker-compose logs
db-1 | 2025-07-01 00:38:58+00:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 1:11.8.2+maria~ubu2404 started.
db-1 | 2025-07-01 00:38:58+00:00 [Warn] [Entrypoint]: /sys/fs/cgroup///memory.pressure not writable, functionality unavailable to MariaDB
db-1 | 2025-07-01 00:38:58+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
db-1 | 2025-07-01 00:38:58+00:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 1:11.8.2+maria~ubu2404 started.
db-1 | 2025-07-01 00:38:58+00:00 [Note] [Entrypoint]: MariaDB upgrade not required
db-1 | 2025-07-01 0:38:58 0 [Note] Starting MariaDB 11.8.2-MariaDB-ubu2404 source revision 8d36cafe4fc700e6e577d5a36650c58707e76b92 server_uid oubInYPqW+Xon+prOFCX7yyhFGg= as process 1
db-1 | 2025-07-01 0:38:58 0 [Note] InnoDB: Compressed tables use zlib 1.3
.....
.....

# run any commands inside a container

# container name is just the one set in [docker-compose.yml]

[sysadmin@podman ~]$ docker-compose exec db /bin/bash
root@1f98c777866a:/# exit
exit

# stop application and also shutdown all containers

[sysadmin@podman ~]$ docker-compose stop
[+] Stopping 1/2
✓ Container root-web-1 Stopped
Container root-db-1 Stopping
[+] Stopping 2/2eth1 (unregistering): left allmulticast mode
✓ Container root-web-1 Stopped
✓ Container root-db-1 Stopped

# start a service alone in application

# if set dependency, other container starts

[sysadmin@podman ~]$ docker-compose up -d web
[+] Running 0/1
Container root-web-1 Recreate
[+] Running 1/1podman1: port 1(veth1) entered blocking state
✓ Container root-web-1 Started

[sysadmin@podman ~]$ docker-compose ps
NAME IMAGE COMMAND SERVICE CREATED STATUS PORTS
root-web-1 docker.io/library/root-web:latest "/usr/sbin/nginx -g …" web 3 minutes ago Up 5 seconds 80/tcp

# remove all containers in application

# if a container is running, it won't be removed

[sysadmin@podman ~]$ docker-compose rm
? Going to remove root-db-1 y
[+] Removing 1/1
✓ Container root-db-1 Removed

```

```

```
