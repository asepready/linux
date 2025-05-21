# RHEL / Rocky Linux # minimalist
```sh
# RHEL/Rocky 8
dnf config-manager --set-enabled powertools

# RHEL/Rocky 9
sudo dnf config-manager --set-enabled crb
sudo dnf install epel-release
sudo dnf clean all
sudo dnf check-update
