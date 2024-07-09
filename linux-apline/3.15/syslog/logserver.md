## Install Paket
```sh
apk add --no-cache rsyslog rsyslog-mysql
```
## Konfigurasi di /etc/rsyslog.conf
```
module(load="ommysql")
action(
        type="ommysql"
        server="localhost"
        serverport="3306"
        db="syslogdb" 
        uid="syslog"
        pwd="syslog"
)

module(load="imudp")
input(
        type="imudp"
        port="514"
)

module(load="imtcp")
input(
        type="imtcp"
        port="514"  
)

```
aktifkan boot dan jalankan
```sh
rc-update add rsyslog;service rsyslog start
```