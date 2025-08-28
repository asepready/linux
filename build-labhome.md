```sh
# How To Install PNETLab v6 From New Site by Online

============================================
https://labhub.eu.org is NOT WORKING

https://drive.labhub.eu.org is New

========================================
Login as ROOT User and update Ubuntu Server
========================================
sudo su -

apt update
apt upgrade
#apt purge netplan.io

apt install libsdl2-dev libsdl2-2.0-0 -y;

# Upgrade PNETLab v6 (20.04)
curl -sSL https://drive.labhub.eu.org/0:/upgrades_pnetlab/focal/install_pnetlab_v6.sh | bash
curl -sSL https://labhub.eu.org/api/raw/?path=/upgrades_pnetlab/focal/install_pnetlab_v6.sh | bash
```
