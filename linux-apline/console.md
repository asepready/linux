```sh
#/boot/extlinux.conf
DEFAULT menu.c32
PROMPT 0
MENU TITLE Alpine/Linux Boot Menu
MENU AUTOBOOT Alpine will be booted automatically in # seconds.
SERIAL 0 9600
TIMEOUT 100
LABEL grsec
  MENU DEFAULT
  MENU LABEL Linux 3.10.33-0-grsec
  LINUX vmlinuz-3.10.33-0-grsec
  INITRD initramfs-3.10.33-0-grsec
  APPEND root=UUID=re-mov-ed-uu-id modules=sd-mod,usb-storage,ext4 console=ttyS0,9600

MENU SEPARATOR