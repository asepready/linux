# How to resize a qcow2 disk image on Linux

This example takes `olddisk.qcow2` and resizes it into `newdisk.qcow2`,
extending one of the guest's partitions to fill the extra space.

## 1. qcow2 format

### 1.1. Verify the filesystems of `olddisk.qcow2`

```sh
virt-filesystems --long -h --all -a olddisk.qcow2
# Name       Type        VFS   Label            MBR  Size  Parent
# /dev/sda1  filesystem  ntfs  System Reserved  -    50M   -
# /dev/sda2  filesystem  ntfs  -                -    39G   -
# /dev/sda3  filesystem  ntfs  -                -    513M  -
# /dev/sda1  partition   -     -                07   50M   /dev/sda
# /dev/sda2  partition   -     -                07   39G   /dev/sda
# /dev/sda3  partition   -     -                27   513M  /dev/sda
# /dev/sda   device      -     -                -    60G   -
```

_Tip: On ArchLinux the `virt-filesystems` tool is under the `libguestfs` package.
So just try a `sudo pacman -Sy libguestfs`_

### 1.2. Create a `newdisk.qcow2` disk image with the new size (E.g 50GB)

```sh
qemu-img create -f qcow2 -o preallocation=metadata newdisk.qcow2 50G
```

### 1.3. Perform the resizing from old disk image to `newdisk.qcow2`

_Note: "/dev/sda2" is a partition inside the `olddisk.qcow2` file which we want to resize._

```sh
virt-resize --expand /dev/sda2 olddisk newdisk.qcow2
```

Done!
Enjoy your new space!

## 2. Raw format (optional alternative)

If you want to create a raw disk instead of a qcow2 try following steps.

### 2.1. Extend the size of `olddisk.qcow2` to the specified size (E.g `+10GB`)

_Note: This will create a new image `newdisk.qcow2` with the given size._

```sh
qemu-img create -f qcow2 \
/home/$USER/kvm/newdisk.qcow2 \
50G

truncate -r olddisk.qcow2 newdisk.qcow2
truncate -s +10G newdisk.qcow2
```

### 2.2. Apply resizing

_Note: "/dev/sda2" is a partition inside the `olddisk.qcow2` file which we want to resize._

```sh
virt-resize --expand /dev/sda2 olddisk.qcow2 newdisk.qcow2
```

### 2.3. Quick inspection of new disk image

```sh
qemu-img info newdisk.qcow2
# image: newdisk.qcow2
# file format: raw
# virtual size: 50 GiB (53693907968 bytes)
# disk size: 36 GiB
```

### 2.4. Verify that the filesystems have grown as expected

```sh
virt-filesystems --long -h --all -a newdisk.qcow2
# Name       Type        VFS   Label            MBR  Size  Parent
# /dev/sda1  filesystem  ntfs  System Reserved  -    50M   -
# /dev/sda2  filesystem  ntfs  -                -    49G   -
# /dev/sda3  filesystem  ntfs  -                -    513M  -
# /dev/sda1  partition   -     -                07   50M   /dev/sda
# /dev/sda2  partition   -     -                07   49G   /dev/sda
# /dev/sda3  partition   -     -                27   513M  /dev/sda
# /dev/sda   device      -     -                -    50G   -
```

For more details and examples please take a look at the official documentation: https://libguestfs.org/virt-resize.1.html
