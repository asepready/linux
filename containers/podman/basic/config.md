```sh
sudo groupadd elastic
sudo groupadd podman

# Add User to Group
sudo useradd -g "elastic" -G "podman" elastic

cat <<EOF | sudo tee /etc/sudoers.d/99-ece-users
elastic ALL=(ALL) NOPASSWD:ALL
EOF

sudo su - elastic

cat <<EOF | sudo tee -a /etc/security/limits.conf
*                soft    nofile         1024000
*                hard    nofile         1024000
*                soft    memlock        unlimited
*                hard    memlock        unlimited
elastic          soft    nofile         1024000
elastic          hard    nofile         1024000
elastic          soft    memlock        unlimited
elastic          hard    memlock        unlimited
root             soft    nofile         1024000
root             hard    nofile         1024000
root             soft    memlock        unlimited
EOF
```
