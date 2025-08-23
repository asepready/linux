============================================================
00:00 How to install PNETLab v6.x.x on VMWare workstation
============================================================
===========================================================
Download ubuntu-20.04.6
===========================================================
00:30 Download ubuntu-20.04.6-live-server-amd64.iso from following link

# https://ubuntu.com/download/server

# 02:00 Verify VMware NAT Network

02:55 Deploy ubuntu-20.04.6 in VMWare workstation or ESXI

04:30 Enable Intel-VT-x/EPT

06:00 Keep Ubuntu version as 20.04 - Continue without updating

08:26 Create pnet user account and pnet password
09:11 Select Install OpenSSH server

========================================================
update ubuntu server
========================================================
sudo apt update
sudo apt upgrade

========================================================
Install PNETLAB
========================================================
Install PNETLab v6 by following command

bash -c "$(curl -sL https://labhub.eu.org/api/raw/?path=/...)"

=== NOTE:Previous bash is not working anymore use following new one =====

bash -c "$(curl -sL https://drive.labhub.eu.org/0:/upgrad...)"

# or

14:40 Download install_pnetlab_v6.sh from following location

https://labhub.eu.org

UNETLAB I
upgrades_pnetlab
Focal
==================================================================
This is offline PNETLab Repository

https://drive.labhub.eu.org/0:/upgrad...

install_pnetlab_v6.sh is located in following path

https://drive.labhub.eu.org/
UNETLAB I
upgrades_pnetlab
Focal
=================================================================

16:40 Upload Script to home Directory

18:20 Then make it executable

chmod +x install_pnetlab_v6.sh

19:15 Then install Script by bash command

sudo bash install_pnetlab_v6.sh

23:20 create root password

========================================================
Install ishare2
========================================================
25:10 https://github.com/ishare2-org/ishare...

26:03 git clone https://github.com/ishare2-org/ishare...
