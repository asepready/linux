## Install Paket
```sh
apk add rsyslog rsyslog-mysql
```
## Konfigurasi di /etc/rsyslog.conf
aktifkan boot dan jalankan
```sh
rc-update add rsyslog;service rsyslog start
```