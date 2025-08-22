# What is VMware?

VMware is a virtualization tool developed by VMware, Inc. This tool developed in 1998, as a subsidiary of Dell Technologies, bases its virtualization technology on the ESX/ESXi in x86 architecture. It allows one to run several operating systems on a single x86-based machine.

This tool has been highly preferred due to the following features:

- It offers better provisioning of applications and resources
- It provides the virtual desktop infrastructure
- Cloud management platform
- Increased efficiency and stability of data center systems
- Simplified data center and cloud infrastructure
- Improved networking and security i.e VMWare NSX
- Has SDDC platform, a software stuck with vSphere, VMware vSAN, and VMware NSX

VMware Workstation Player and VMware Workstation Pro are the two Client PC Versions. One is able to run multiple operating systems from the host system that runs Windows, Linux, macOS e.t.c. The two applications have differences:

- VMware Workstation Player is a free, more basic, and non-commercial tool.
- VMware Workstation Pro requires a license and offers more advanced and professional virtualization.

The advanced features provided by VMware Workstation Pro are:

- Ability to create Linked Clones and full clones
- Virtual Network Customization (NAT, network rename)
- Remote vSphere Host Power Control
- Allows snapshots
- Creating and managing Encrypted VMs
- Virtual Network Simulation (Packet Loss, Latency, Bandwidth)

# System Requirements

To be able to install and use VMware Workstation / Player, you need a system that meets the below specifications:

- CPU – above 2GHz and 64-bit processor
- Memory – above 2GB RAM, recommended 4GB
- Additional space and memory are required for each virtual machine.

You also need to have Virtualization enabled in BIOS. This can be checked using the command:

```sh
$ lscpu | grep Virtualization
Virtualization: VT-x
Virtualization type: full
```

Ensure that you are running a 64-bit system:

```sh
$ lscpu
Architecture: x86_64
CPU op-mode(s): 32-bit, 64-bit
Address sizes: 39 bits physical, 48 bits virtual
Byte Order: Little Endian
CPU(s): 3
On-line CPU(s) list: 0-2
Vendor ID: GenuineIntel
Model name: Intel(R) Xeon(R) CPU E3-1275 v5 @ 3.60GHz
CPU family: 6
Model: 94

#Step 1 – Install Build Tools on Rocky Linux 9
#There are quite a number of development tools required to install VMware Workstation / Player.

#First, add the EPEL repository to the system.

sudo dnf install epel-release

#Now install the required build tools:

sudo dnf install gcc make perl kernel-devel kernel-headers bzip2 dkms elfutils-libelf-devel
sudo yum groupinstall "Development Tools"

#Once complete, compare the kernel-devel and the kernel versions:

$ rpm -q kernel-devel
kernel-devel-5.14.0-70.17.1.el9_0.x86_64

$ uname -r
5.14.0-70.13.1.el9_0.x86_64
The two versions need to match. If not, update the kernel and reboot the system

sudo dnf update kernel-\*
sudo reboot now

#Now the two versions should match.

#Step 2 – Download VMware Workstation / Player on Rocky Linux 9
#Depending on your preferences, download the VMware Workstation tool that works best for you.

#VMware Workstation Player
#This tool can be downloaded from the official VMware Player downloads page.

#VMware WorkstationPlayer 16 on Rocky Linux 9
#You can also use wget to pull the version.

wget https://download3.vmware.com/software/WKST-PLAYER-1624/VMware-Player-Full-16.2.4-20089737.x86_64.bundle

#VMware Workstation Pro
#VMware Workstation Pro can be downloaded from the VMware Workstation Pro downloads page

#VMware WorkstationPlayer 16 on Rocky Linux 9 18
#You can also pull the version using wget;

wget https://download3.vmware.com/software/WKST-1624-LX/VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle

#Step 3 – Install VMware Workstation / Player on Rocky Linux 9
#Once the desired edition has been downloaded, navigate to the download path and make the file executable:

# For VMware Player
chmod +x VMware-Player-\*.x86_64.bundle

#For VMware Workstation Pro
chmod +x VMware-Workstation-Full-\*.x86_64.bundle

#Now install VMware Workstation / Player on Rocky Linux 9 using the command:

#For VMware Player
sudo ./VMware-Player-\*.x86_64.bundle

#For Workstation pro
sudo ./VMware-Workstation-Full-\*.x86_64.bundle

#Sample output:
Extracting VMware Installer...done.
System service scripts directory (commonly /etc/init.d).: /etc/init.d

Installing VMware Installer 3.0.0
Copying files...
Installing VMware VMX 16.2.4
Configuring...No rc\*.d style init script directories were given to the installer.################################ ] 51%
You must manually add the necessary links to ensure that the vmware
service at /etc/init.d/vmware is automatically started and stopped on
Installing VMware Workstation 16.2.4
Configuring...
[######################################################################] 100%
Installation was successful.

#Once complete, install the required VMware modules:
sudo vmware-modconfig --console --install-all

#Verify the installation.
$ sudo vmware-modconfig --install-status
[AppLoader] Use shipped PC/SC Lite smart card framework.
An up-to-date "pcsc-lite-libs" or "libpcsclite1" package from your system is preferred.
[AppLoader] GLib does not have GSettings support.
vmmon: installed
vmnet: installed

#Step 4 – Using VMware Workstation / Player on Rocky Linux 9
#Now VMware Workstation / Player is ready for use and can be launched from the app Menu as shown.
# VMware WorkstationPlayer 16 on Rocky Linux 9 1
#Agree to the License Terms

#Step 5 – Install VMware Tools on Rocky Linux 9
#The VMware Tools are used to provide maximum performance for the VM. It provides a closer integration between the host and the guest OS by providing:

#- Clock synchronization
#- Shared clipboard
#- Mouse pointer integration
#- Improve graphical performance
#- Folder sharing

#In order to achieve all that, you need the VMware Tools installed on your guest OS. This can be done on Rocky Linux 9 guest OS as shown.

#The easiest way to install VMware Tools is by using open-vm-tools which is an open-source implementation for f VMware tools available for Linux distributions.

#For Rhel-based systems such as Rocky Linux 9, use the command:
sudo dnf -y install open-vm-tools

#On other systems such as Debian/Ubuntu, use the command:
sudo apt-get install open-vm-tools

#Once the installation is complete, check the version:
$ sudo /usr/bin/vmware-toolbox-cmd -v
11.3.5.31214 (build-18557794)

# Enable File sharing between host and guest
#With VMware tools installed, power off the VM and enable File sharing between host and guest by navigating to Edit Virtual Machine Settings-> Options->shared folders and click +

#VMware WorkstationPlayer 16 on Rocky Linux 9 15
#To enable copy and paste/drag and drop navigate to Edit Virtual Machine Settings-> Options-> Guest Isolation

#VMware WorkstationPlayer 16 on Rocky Linux 9 16
#Now power on the VM and run the command below to temporarily mount the shared folder:

vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other

#You can also mount the folder permanently in the /etc/fstab by adding the lines:
$ sudo vim /etc/fstab
.host:/ /mnt/hgfs fuse.vmhgfs-fuse allow_other 0 0

#Verify that the shared folder is accessible under /mnt/hgfs
```

https://computingforgeeks.com/install-vmware-workstation-player-rocky/
