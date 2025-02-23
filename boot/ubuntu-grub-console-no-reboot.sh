#!/bin/bash
# Works with Kali latest releases
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
cat << EOF > /etc/default/grub
# grub-mkconfig -o /boot/grub/grub.cfg
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="console=tty1 console=ttyS0,115200"
GRUB_CMDLINE_LINUX="initrd=/install/initrd.gz net.ifnames=0 biosdevname=0"
GRUB_TERMINAL="console serial"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
EOF
grub-mkconfig -o /boot/grub/grub.cfg