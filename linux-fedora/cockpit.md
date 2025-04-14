Cockpit comes installed by default in Server.

```sh
# Fedora
sudo dnf install cockpit

sudo systemctl enable --now cockpit.socket

sudo firewall-cmd --add-service=cockpit
sudo firewall-cmd --add-service=cockpit --permanent
