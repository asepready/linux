```sh
# Gen-Key
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Copy Key
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@my-server-ip

# Test Conn
ssh user@my-server-ip podman info | grep sock

# Add The Conn
podman system connection add my-remote-machine --identity ~/.ssh/id_ed25519 ssh://myuser@my-server-ip/run/user/1000/podman/podman.sock
```
