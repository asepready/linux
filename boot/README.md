- [Remove OldKernel on Fedora/RHEL](https://fostips.com/remove-old-kernels-fedora-rhel/)
- [Remove OldKernel on Ubuntu/Debian](https://ostechnix.com/remove-old-unused-linux-kernels/)

Update and Costum grub2 conf
```sh
#/etc/default/grub
GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/rl_rocky--linux-swap rd.lvm.lv=rl_rocky-linux/root rd.lvm.lv=rl_rocky-linux/swap rhgb quiet rd.driver.blacklist=nouveau"

## BIOS ##
grub2-mkconfig -o /boot/grub2/grub.cfg
## UEFI CentOS Stream 9/8 ##
grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
## UEFI Red Hat (RHEL) 9.0/8.5 ##
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
## UEFI Rocky Linux 8.5 ##
grub2-mkconfig -o /boot/efi/EFI/rocky/grub.cfg
```

Generate initramfs
```sh
mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
 
## Create new initramfs image ##
dracut /boot/initramfs-$(uname -r).img $(uname -r)
```

Remove kernel
```sh
# RHEL 9/8 and Rocky 9/8
sudo dnf remove kernel-version
package-cleanup --kernel-version
```
