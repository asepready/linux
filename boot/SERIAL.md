# Serial console for KVM based VM and IPMI serial channel

## grub and kernel console

Set in `/etc/default/grub`:

```sh
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200 earlyprintk=ttyS0,115200 >
GRUB_TERMINAL_OUTPUT="gfxterm serial"
GRUB_SERIAL_COMMAND="serial --speed=115200"
```

Refresh grub using

```
grub2-mkconfig -o /boot/grub2/grub.cfg # CentOS, RHEL
```

or

```
update-grub2 # debian (et al)
```

## Legacy grub

RHEL 6 based distributions, like Scientific Linux 6 or CentOS 6 use the older _legacy_ (v1) grub, where the user edits `/boot/grub/grub.cfg`directly. To get grub to use the serial console for displying the menu, the config file should contain, before the `hidemenu` line:

```sh
splashimage=(hd0,0)/grub/splash.xpm.gz
serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
terminal --timeout=5 serial console
:hiddenmenu
```

To activate the serial kernel console, for booting and shutdown messages, the kernel comand line should end in

```
... rhgb console=tty0 console=ttyS0,115200n8
```

instead of

```
... rhgb quiet
```

This will automatically activate the `getty` program on the serial console to provide the login prompt on the serial console.

## RHEL / Rocky / ALma 8

In the RHEL 8 family, kernel boot parameters are managed with the `grub2-editenv` command and have to be set **after updating the grub.cfg file as mentioned above**.

You have to manually add the console information. To do that, you first have to get the current setting of the parameters:

```sh
# grub2-editenv - list | grep kernelopts
kernelopts=root=/dev/mapper/almalinux-root ro crashkernel=auto resume=/dev/mapper/almalinux-swap rd.lvm.lv=almalinux/root rd.lvm.lv=almalinux/swap rhgb quiet
```

If there is a `quiet` option, you probably want to remove it and then add `console=tty0 console=ttyS0,115200n8`:

```sh
grub2-editenv - set "kernelopts=root=/dev/mapper/almalinux-root ro crashkernel=auto resume=/dev/mapper/almalinux-swap rd.lvm.lv=almalinux/root rd.lvm.lv=almalinux/swap rhgb console=tty0 console=ttyS0,115200n8"
```

and finally check the result:

```sh
# grub2-editenv - list | grep kernelopts
kernelopts=root=/dev/mapper/almalinux-root ro crashkernel=auto resume=/dev/mapper/almalinux-swap rd.lvm.lv=almalinux/root rd.lvm.lv=almalinux/swap rhgb console=tty0 console=ttyS0,115200n8
```

## RHEL / Rocky / ALma 9

In the RHEL 9 family, kernel boot parameters are managed with the `grubby` command and have to be set **after updating the grub.cfg file as mentioned above**.

To check the current settings, use

```sh
# grubby --info=ALL | grep -i args
args="ro crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M resume=/dev/mapper/almalinux-swap rd.lvm.lv=almalinux/root rd.lvm.lv=almalinux/swap"
```

To add the arguments for setting the console to the kernel command line, execute:

```sh
grubby --update-kernel=ALL --args="console=tty0 console=ttyS0,115200"
```

## Linux console

Systemd based distributions start a `getty` process for the serial console automatically when they detect the serial console option on the kernel command line. It should **NOT** be necessary to activate the serial console manually.

### Manual activation of the serial console

For reference, the command to activate the serial console manually is

```
systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service
```

## VM configuration (libvirt based)

Your VM has to have a serial console configured. Make sure the console configuration of the VM is set to `serial`, not `virtio` for if you want to be able to use the console for grub and in single user mode. Verify that you see something like

```
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
```

when looking at the output of `virsh dumpxml vm-name`. The important setting is the `type` attribute of the `target` tag. Other tags and atributes can be set.

### Using `virtio` vs `serial` type for console

Using the `serial` type for the console, you get the usual `/dev/ttyS0` console. Using `virtio`, you get `/dev/hvc0` as the console device. Most modern linux distributions automaticallt start a `getty` process when they detect the presence of a serial console. To detect the presence of a `serial` console, the kernal command line has to contain `console=ttyS0`, wheares a `virtio` console is detected by the presence of `/dev/hvc0`. This means you can get a serial console to a fully booted system without any additional configuration of the client machine when you use the `virtio` driver.

To get kernel output to the serial console during booting or in case of failures, you need to activate the serial console on the kernel command line. This can be done with either driver. It seems that there is no module in grub for the `virtio` driver. This means you have to use the `serial` driver to be able to use the serial console to pick or edit entries from the grub boot menu.

Bottom line: use `virtio` if you only care about console login to a working system and your distribution automatically starts a `getty` process on `/dev/hvc0`. For full control for the boot process and to be able to use the serial console to debug and fix problems booting, use the `serial` driver and configure grub and your kernel as described above.

## Using the serial console for remote administration

Remote administration tools like IPMI provide access to a serial console. This is a minimal console, which uses less network bandwitdh than the graphical console provided by remote admin tools. Also, the remote graphical console often requires Java or proprietory tools. The serial console will often use a different serial console, e.g., you might have to substitue `ttyS1` (or a different number) for `ttyS0` in the examples listed above. With `ipmitool`, the command access to connect to the serial console on a remove server looks something like

```
ipmitool -H remote-ipmi-host -U remote-user -LOPERATOR -I lanplus sol activate
```
