# Podman : Create Pods

Create Pods like Kubernetes.

[1] Create a Pod and add a Container to it.

```sh
# create a empty pod
# -p [bind port] -n [pod name]
[sysadmin@podman ~]$ podman pod create -p 8081:80 -n my-pod
06e2a4dcd0f30690a9289f4a514ada49b38bcd3e59940009075a3fdfcd1dae02

# show pods
[sysadmin@podman ~]$ podman pod ls
POD ID        NAME        STATUS      CREATED        INFRA ID      # OF CONTAINERS
06e2a4dcd0f3  my-pod    Created     9 seconds ago  4958d8fcffa1  1

# show details of pod
[sysadmin@podman ~]$ podman pod inspect my-pod
[
     {
          "Id": "06e2a4dcd0f30690a9289f4a514ada49b38bcd3e59940009075a3fdfcd1dae02",
          "Name": "my-pod",
          "Created": "2025-07-01T09:44:11.400262401+09:00",
          "CreateCommand": [
               "podman",
               "pod",
               "create",
               "-p",
               "8081:80",
               "-n",
               "my-pod"
          ],
          "ExitPolicy": "continue",
          "State": "Created",
          "Hostname": "",
          "CreateCgroup": true,
          "CgroupParent": "machine.slice",
          "CgroupPath": "machine.slice/machine-libpod_pod_06e2a4dcd0f30690a9289f4a514ada49b38bcd3e59940009075a3fdfcd1dae02.slice",
          "CreateInfra": true,
          "InfraContainerID": "4958d8fcffa119b129c3db07ae0b1d1f83885244cd5880f29a77f9de689be70d",
          "InfraConfig": {
               "PortBindings": {
                    "80/tcp": [
                         {
                              "HostIp": "0.0.0.0",
                              "HostPort": "8081"
                         }
                    ]
               },
               "HostNetwork": false,
               "StaticIP": "",
               "StaticMAC": "",
               "NoManageResolvConf": false,
               "DNSServer": null,
               "DNSSearch": null,
               "DNSOption": null,
               "NoManageHostname": false,
               "NoManageHosts": false,
               "HostAdd": null,
               "HostsFile": "",
               "Networks": [
                    "podman"
               ],
               "NetworkOptions": null,
               "pid_ns": "private",
               "userns": "host",
               "uts_ns": "private"
          },
          "SharedNamespaces": [
               "ipc",
               "net",
               "uts"
          ],
          "NumContainers": 1,
          "Containers": [
               {
                    "Id": "4958d8fcffa119b129c3db07ae0b1d1f83885244cd5880f29a77f9de689be70d",
                    "Name": "06e2a4dcd0f3-infra",
                    "State": "created"
               }
          ],
          "LockNumber": 15
     }
]

[sysadmin@podman ~]$ podman images
REPOSITORY                     TAG               IMAGE ID      CREATED             SIZE
localhost/podman-pause         5.4.0-1750148132  5ce2e1f9a573  About a minute ago  822 kB
localhost/iproute              latest            00c630e23081  About an hour ago   313 MB
localhost/rl8-httpd            latest            fbbfe2391d52  3 hours ago         582 MB
localhost:5000/rl8             latest            36ab69d52e1c  3 hours ago         211 MB
localhost/rl8                  latest            36ab69d52e1c  3 hours ago         211 MB
localhost/rl8-nginx            latest            cdd05264c534  3 hours ago         382 MB
quay.io/rockylinux/rockylinux  latest            86f02aa837b3  3 years ago         211 MB
quay.io/libpod/registry        2                 2d4f4b5309b1  5 years ago         26.8 MB

# run container and add it to pod
[sysadmin@podman ~]$ podman run -dt --pod my-pod srv.world/rocky-nginx
cb6a13a9efd0ebdf402a8ea1201bce701b29ea2a7cab4fb161166720b285e43f

[sysadmin@podman ~]$ podman ps
CONTAINER ID  IMAGE                                    COMMAND               CREATED         STATUS         PORTS                   NAMES
6251ea4359e7  quay.io/libpod/registry:2                /etc/docker/regis...  3 hours ago     Up 3 hours     0.0.0.0:5000->5000/tcp  registry
8c3f461435fa  localhost/podman-pause:5.4.0-1750148132                        2 minutes ago   Up 10 seconds  0.0.0.0:8081->80/tcp    ce4f6e43b0b0-infra
59060ab0d0e3  localhost/rl8-nginx:latest               /usr/sbin/nginx -...  10 seconds ago  Up 10 seconds  0.0.0.0:8081->80/tcp    practical_lamport

# verify accesses
[sysadmin@podman ~]$ curl localhost:8081
Podman Test on Nginx
# stop pod
[sysadmin@podman ~]$ podman pod stop my-pod
my-pod

# remove pod (removed containers all)
[sysadmin@podman ~]$ podman pod rm my-pod --force
06e2a4dcd0f30690a9289f4a514ada49b38bcd3e59940009075a3fdfcd1dae02
```

[2] It's possible to create Pod and add Container with one command.

```sh
[sysadmin@podman ~]$ podman images
REPOSITORY                     TAG               IMAGE ID      CREATED            SIZE
localhost/podman-pause         5.4.0-1750148132  5ce2e1f9a573  4 minutes ago      822 kB
localhost/iproute              latest            00c630e23081  About an hour ago  313 MB
localhost/rl8-httpd            latest            fbbfe2391d52  3 hours ago        582 MB
localhost:5000/rl8             latest            36ab69d52e1c  3 hours ago        211 MB
localhost/rl8                  latest            36ab69d52e1c  3 hours ago        211 MB
localhost/rl8-nginx            latest            cdd05264c534  3 hours ago        382 MB
quay.io/rockylinux/rockylinux  latest            86f02aa837b3  3 years ago        211 MB
quay.io/libpod/registry        2                 2d4f4b5309b1  5 years ago        26.8 MB

# create a [test_pod2] pod and add [srv.world/centos-nginx] container
[sysadmin@podman ~]$ podman run -dt --pod new:my-pod2 -p 80:80 -p 3306:3306 localhost/rl8-nginx
e461864f10d3f7496a690ab3ddd4074efbd61e8f3e5d53b4ca4a76c779ffa449

[sysadmin@podman ~]$ podman pod ls
POD ID        NAME        STATUS      CREATED         INFRA ID      # OF CONTAINERS
b377e19ce447  my-pod2   Running     16 seconds ago  ed9bf7cea6b5  2

[sysadmin@podman ~]$ podman ps
CONTAINER ID  IMAGE                                    COMMAND               CREATED         STATUS         PORTS                                       NAMES
ed9bf7cea6b5  localhost/podman-pause:5.4.0-1748995200                        28 seconds ago  Up 29 seconds  0.0.0.0:80->80/tcp, 0.0.0.0:3306->3306/tcp  b377e19ce447-infra
e461864f10d3  srv.world/rocky-nginx:latest             /usr/sbin/nginx -...  28 seconds ago  Up 29 seconds  0.0.0.0:80->80/tcp, 0.0.0.0:3306->3306/tcp  festive_williamson

# run [mariadb] container and add it to the [my-pod2]
[sysadmin@podman ~]$ podman run -dt --pod my-pod2 -e MYSQL_ROOT_PASSWORD=Password quay.io/sclorg/mariadb-103-c8s
4d634e9c68efae0b76a609075d02d2a99068942a4adaff40ceb8bfe98e53e0aa

[sysadmin@podman ~]$ podman ps
CONTAINER ID  IMAGE                                    COMMAND               CREATED         STATUS         PORTS                                       NAMES
f62687381bd3  localhost/podman-pause:5.4.0-1750148132                        5 minutes ago   Up 5 minutes   0.0.0.0:80->80/tcp, 0.0.0.0:3306->3306/tcp  b8c3b36748f3-infra
0ffc4aedf890  localhost/rl8-nginx:latest               /usr/sbin/nginx -...  5 minutes ago   Up 5 minutes   0.0.0.0:80->80/tcp, 0.0.0.0:3306->3306/tcp  heuristic_saha
27af3605a43e  quay.io/sclorg/mariadb-103-c8s:latest    run-mysqld            19 seconds ago  Up 20 seconds  0.0.0.0:80->80/tcp, 0.0.0.0:3306->3306/tcp  stoic_herschel


[sysadmin@podman ~]$ curl localhost
Dockerfile Test on Nginx
[sysadmin@podman ~]$ mysql -u root -p -h localhost -e "show variables like 'hostname';"
Enter password:
+---------------+-----------+
| Variable_name | Value     |
+---------------+-----------+
| hostname      | my-pod2 |
+---------------+-----------+
```
