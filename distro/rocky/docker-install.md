```sh
# Allow Kernel
cat <<EOF | sudo tee /etc/sysctl.d/1-ipforward.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

cat <<EOF | sudo tee /etc/sysctl.d/container.conf
net.ipv4.ip_unprivileged_port_start=0
fs.file-max = 65536
vm.max_map_count=262144
EOF

sudo sysctl --system


# Remove old packages
sudo dnf remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine \
    podman \
    runc

# Install using the rpm repository
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Systemd
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Uninstall Docker Engine
#############################################################
sudo dnf remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
