```sh
sudo dnf update
sudo dnf install -y virtualbox

sudo usermod -aG vboxusers $USER

#check module kernel
lsmod | grep vbox
----
vboxnetadp             32768  0
vboxnetflt             40960  0
vboxdrv               733184  2 vboxnetadp,vboxnetflt
----

#not output module kernel
sudo dnf install -y kernel-devel dkms gcc make
sudo /sbin/vboxconfig # build kernel module for vbox

# permission adapter
#/etc/udev/rules.d/60-vboxdrv.rules
KERNEL=="vboxdrv", OWNER="root", GROUP="vboxusers", MODE="0660"
KERNEL=="vboxnetctl", OWNER="root", GROUP="vboxusers", MODE="0660"

sudo udevadm control --reload-rules #reload set udev
sudo udevadm trigger

# verifi
VBoxManage list hostonlyifs
