## System settings

```sh
$ sudo hostnamectl  --static hostname "kickass-workstation"
```

## Enable extra repositories

```sh
$ sudo dnf -y update
$ sudo dnf config-manager --set-enabled crb
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
$ ARCH=$(/bin/arch)
$ distribution=$(. /etc/os-release;echo $ID`rpm -E "%{?rhel}%{?fedora}"`)
$ sudo dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/$distribution/${ARCH}/cuda-rhel8.repo
$ sudo dnf install -y kernel kernel-core kernel-modules \
kernel-devel-$(uname -r) kernel-headers-$(uname -r)
$ sudo dnf module install nvidia-driver
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
