# Fix System Crash Debian/Ubuntu
Cek di direktori /var/crash, dengan perintah:
```sh
ls -l /var/crash
```
Dan hapuskan dengan perintah:
```sh
sudo rm /var/crash/*
```

# Disable peringatan pada System crash pada Debian/Ubuntu
Edit file pada direktori /etc/default/apport
```sh
sudo nano /etc/default/apport
```
```sh
# set this to 0 to disable apport, or to 1 to enable it
# you can temporarily override this with
# sudo service apport start force_start=1
enabled=1
```
