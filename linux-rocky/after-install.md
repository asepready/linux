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
# Cude NVIDIA
sudo dnf install epel-release -y
sudo dnf groupinstall "Development Tools" -y
sudo dnf install kernel-devel -y
sudo dnf install dkms -y
### Add Repo
sudo dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel9/$(uname -i)/cuda-rhel9.repo

# Dependencies
sudo dnf install kernel-headers-$(uname -r) kernel-devel-$(uname -r) tar bzip2 make automake gcc gcc-c++ pciutils elfutils-libelf-devel libglvnd-opengl libglvnd-glx libglvnd-devel acpid pkgconf dkms -y

sudo dnf module install nvidia-driver:latest-dkms -y

# Disable nouveau in GRUB
sudo grubby --args="nouveau.modeset=0 rd.driver.blacklist=nouveau" --update-kernel=ALL
#!/etc/default/grub
GRUB_CMDLINE_LINUX="resume=/dev/mapper/rl_localhost--live-swap rd.lvm.lv=rl_localhost-live/root rd.lvm.lv=rl_localhost-live/swap crashkernel=auto rhgb quiet nouveau.modeset=0 rd.driver.blacklist=nouveau"

# For systems with secure boot enabled you need to perform this step:
sudo mokutil --import /var/lib/dkms/mok.pub

#########RESTART##########
sudo reboot

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
$ sudo dnf -y install https://repo.radeon.com/amdgpu-install/latest/rhel/9.6/amdgpu-install-6.4.60401-1.el9.noarch.rpm
$ sudo amdgpu-install -y --accept-eulaEferfr
```

## Reboot your Rocky Linux system

```sh
$ sudo reboot
```
