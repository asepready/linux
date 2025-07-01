## System settings

```sh
$ sudo hostnamectl  --static hostname "kickass-workstation"
```

## Enable extra repositories

```sh
$ sudo dnf -y update
$ sudo dnf config-manager --set-enabled powertools # RL8
$ sudo dnf config-manager --set-enabled crb # RL9
$ sudo dnf -y install epel-release
```

## Extra desktop environments

```sh
# For DE KDE
$ sudo dnf -y groupinstall "KDE Plasma Workspaces"

# Or DE XFCE
$ sudo dnf -y groupinstall "Xfce"
```

## Extra productivity applications

```sh
$ dnf -y install libreoffice-\*
$ sudo dnf -y install <https://zoom.us/client/latest/zoom_x86_64.rpm>
```

## Optional developer apps

```sh
$ sudo dnf -y groupinstall "Development Tools"
$ sudo dnf -y install git
```

## Optional apps for scientists and researchers

```sh
$ sudo dnf -y groupinstall "Scientific Support"
```

## Optional apps and tools for system administrators

```sh
$ sudo dnf groupinstall "System Tools" "Container Management"
$ sudo dnf -y install ansible-core
```

## Optional apps and tools for security professionals

```sh
$ sudo dnf -y groupinfo "Security Tools"
```

## Proprietary GPU drivers for Rocky Linux

Get your GPU firing on all cylinders. If you’ve got proprietary GPU hardware, you’ll want to install appropriate drivers directly from your card’s vendor.

### NVIDIA GPU drivers for Rocky Linux

```sh
sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm
sudo dnf install xorg-x11-server-Xorg xorg-x11-xauth -y

# KDE
sudo dnf install plasma-desktop kscreen sddm kde-gtk-config dolphin konsole kate plasma-discover firefox rocky-backgrounds sddm-breeze mpv  -y

# Cude NVIDIA
sudo dnf groupinstall "Development Tools"
sudo dnf install kernel-devel epel-release
sudo dnf install dkms
sudo dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel9/$(uname -i)/cuda-rhel9.repo

# Dependencies
sudo dnf install kernel-headers-$(uname -r) kernel-devel-$(uname -r) tar bzip2 make automake gcc gcc-c++ pciutils elfutils-libelf-devel libglvnd-opengl libglvnd-glx libglvnd-devel acpid pkgconfig dkms

sudo dnf module install nvidia-driver:latest-dkms

# Disable nouveau in GRUB
#!/etc/default/grub
#GRUB_CMDLINE_LINUX="resume=/dev/mapper/rl_localhost--live-swap rd.lvm.lv=rl_localhost-live/root rd.lvm.lv=rl_localhost-live/swap crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M rhgb quiet intel_iommu=on rd.driver.blacklist=nouveau"
GRUB_CMDLINE_LINUX="resume=/dev/mapper/rl_localhost--live-swap rd.lvm.lv=rl_localhost-live/root rd.lvm.lv=rl_localhost-live/swap crashkernel=auto rhgb quiet nouveau.modeset=0 rd.driver.blacklist=nouveau"

# BIOS
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# EFI
sudo grub2-mkconfig -o /boot/efi/EFI/rocky/grub.cfg

# LOGIN NVIDIA
nvidia-smi

# Set to boot to KDE
sudo systemctl set-default graphical.target
sudo systemctl enable sddm

# Install Flatpak
sudo dnf install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# POST INSTALL
# Download link: https://www.blackmagicdesign.com/products/davinciresolve
sudo dnf install apr apr-util mesa-libGLU
./DaVinci_Resolve_18.6.4_Linux.run
```

### AMD GPU drivers for Rocky Linux

```sh
$ sudo dnf -y install <https://repo.radeon.com/amdgpu-install/latest/rhel/9.4/amdgpu-install-6.1.60102-1.el9.noarch.rpm>
$ sudo amdgpu-install -y --accept-eulaEferfr
```

## Reboot your Rocky Linux system

```sh
$ sudo reboot
```
