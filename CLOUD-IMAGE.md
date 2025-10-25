1.                 Download the ubuntu 16.04 qcow2 cloud image from https://cloud-images.ubuntu.com/xenial/current/.(ex: Downloaded image xenial-server-cloudimg-amd64-disk1.img)

2.                 Install guestfish in your server. Guestfish is a shell and command-line tool for examining and modifying virtual machine filesystems.

```sh
# Ubuntu 16.04 Host machine
apt-get install guestfish

#Ubuntu 18.04 Host machine
apt-get install libguestfs-tools
```

3.                In order to edit the image file open it with guestfish: (Here xenial-server-cloudimg-amd64-disk1.img is the cloud for which we are setting the default password.)

```sh
guestfish --rw -a xenial-server-cloudimg-amd64-disk1.img
```

4. start the image file by executing "run " command as in the below snippet.

This snippet has complete complete steps from 3 to 7.

```sh
root@controller:/home/anantha# guestfish --rw -a xenial-server-cloudimg-amd64-disk1.img

Welcome to guestfish, the guest filesystem shell for
editing virtual machine filesystems and disk images.

Type: 'help' for help on commands
      'man' to read the manual
      'quit' to quit the shell

><fs> run
><fs> list-filesystems
/dev/sda1: ext4
><fs> mount /dev/sda1 /
><fs> vi /etc/cloud/cloud.cfg
><fs> exit
```

5. Find the image local disk by running "list-filesystems" command.

```sh
> <fs> list-filesystems
> /dev/sda1: ext4
```

6. Mount the image disk to guestfish root using mount command.

```sh
> <fs> mount /dev/sda1 /
```

7. Edit /etc/cloud/cloud.cfg file in order to load whatever you want, when instance created, etc.. In case you want to set user password for ubuntu user, you should add these lines to the cloud.cfg file:

```sh
> <fs> vi /etc/cloud/cloud.cfg
> password: ubuntu
> chpasswd: { expire: False }
> ssh_pwauth: True

> <fs> exit
> Save and exit from guestfish.
```

8. Now create the openstack glance image with the following command.

```sh
openstack image create "ubuntu16.04" --file xenial-server-cloudimg-amd64-disk1.img
--disk-format qcow2 --container-format bare
```

9. Create openstack instance with this image . And you will able to do ssh connection with user “ubuntu” and password “ubuntu”.

THESE STEPS WORKED FOR OPENSTACK QUEENS AND ROCKY RELEASES.
