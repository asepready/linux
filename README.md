# Linux

Learn Linux Administrator

- [40 Linux Server Hardening Security Tips](https://www.cyberciti.biz/tips/linux-security.html)
- https://redmine.lighttpd.net/projects/lighttpd/wiki/TutorialConfiguration

```sh
# Deleting the package cache
sudo apt clean
sudo dnf clean all

# Deleting other clear caches [value 1 to pageCache, 2 to dentries and inodes, 3 to pageCache, dentries, and inodes ]
sudo sysctl vm.drop_caches=1|2|3

# Remove temporary files
------
# Edit /usr/lib/systemd/system/systemd-tmpfiles-clean.timer
OnBootSec=15min
OnUnitActiveSec=1d
------

sudo systemctl daemon-reload
sudo systemctl enable --now systemd-tmpfiles-clean.timer

# Clear Logs
sudo find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;
```
