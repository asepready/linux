## Setup Ubuntu firewall with UFW
```sh
# Enable IPv6
# edit file /etc/default/ufw
IPV6=yes

# Set Up Default Policies111
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH Connections
sudo ufw app list
sudo ufw allow OpenSSH # allowing the OpenSSH UFW Application Profile
#or
sudo ufw allow ssh # allowing by service
#or
sudo ufw allow 22 # allowing by port

# Enabling UFW
sudo ufw show added
sudo ufw enable

# Allow Any Other Required Connections
sudo ufw allow ‘Apache Full’
sudo ufw allow ‘Nginx Full’

sudo ufw allow 6000:6007/tcp # Specific Port Ranges
sudo ufw allow 6000:6007/udp

sudo ufw allow from 203.0.113.4 # Specific IP Addresses
sudo ufw allow from 203.0.113.4 to any port 22

sudo ufw allow from 203.0.113.0/24 # Specific IP Subnets
sudo ufw allow from 203.0.113.0/24 to any port 22

ip addr # Connections to a Specific Network Interface
sudo ufw allow in on eth0 to any port 80
sudo ufw allow in on eth1 to any port 3306

# Denying Connections
sudo ufw app list
sudo ufw deny OpenSSH #Denying the OpenSSH UFW Application Profile
#or
sudo ufw deny ssh #Denying by service
#or
sudo ufw deny 22 #Denying by port

sudo ufw deny from 203.0.113.4 
sudo ufw deny out 25

# Deleting Firewall Rules
sudo ufw status numbered
sudo ufw delete 2 #Deleting a UFW Rule By Number
sudo ufw delete allow "Apache Full" #Deleting a UFW Rule By Name
sudo ufw delete allow http #Deleting a UFW Rule By Service
sudo ufw delete allow 80 #Deleting a UFW Rule By Port

# Check UFW Status and Rules
sudo ufw status verbose

# How to Disable or Reset Firewall on Ubuntu
sudo ufw disable
sudo ufw reset
```

## Protect Ubuntu Server Against DOS Attacks with UFW
```sh
#/etc/ufw/before.rules
:ufw-http - [0:0]
:ufw-http-logdrop - [0:0]

EX:
*filter
:ufw-http - [0:0]
:ufw-http-logdrop - [0:0]

:ufw-before-input - [0:0]
:ufw-before-output - [0:0]
:ufw-before-forward - [0:0]
:ufw-not-local - [0:0]

### start ###
# Enter rule
-A ufw-before-input -p tcp --dport 80 -j ufw-http
-A ufw-before-input -p tcp --dport 443 -j ufw-http

# Limit connections per Class C
-A ufw-http -p tcp --syn -m connlimit --connlimit-above 50 --connlimit-mask 24 -j ufw-http-logdrop

# Limit connections per IP
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --set
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --update --seconds 10 --hitcount 20 -j ufw-http-logdrop

# Limit packets per IP
-A ufw-http -m recent --name pack_per_ip --set
-A ufw-http -m recent --name pack_per_ip --update --seconds 1 --hitcount 20 -j ufw-http-logdrop

# Finally accept
-A ufw-http -j ACCEPT

# Log
-A ufw-http-logdrop -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW HTTP DROP] "
-A ufw-http-logdrop -j DROP
### end ###

```
sudo ufw reload