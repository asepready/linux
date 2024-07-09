## Install Paket
```sh
apk add --no-cache rsyslog rsyslog-mysql
```
## Konfigurasi di /etc/rsyslog.d/mysqldb.conf
```sh
module(load="ommysql")
action(
        type="ommysql"
        server="localhost"
        serverport="3306"
        db="syslogdb" 
        uid="syslog"
        pwd="syslog"
)
```

aktifkan boot dan jalankan
```sh
mkdir /etc/rsyslog.d;chown -R root:adm /etc/rsyslog.d
cat > /etc/rsyslog.d/network-logs.conf << EOF
#################
#### MODULES ####
#################

#provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")

#provides TCP syslog reception
module(load="imtcp")
input(type="imtcp" port="5140")

#$AllowedSender TCP, 127.0.0.1, 172.19.0.0/16, 192.168.10.0/24, 192.168.20.0/24, 192.16.254.0/24, 192.168.111.0/24

#Custom template to generate the log filename dynamically based on the client's IP address or Hostname.
$template remote-incoming-logs,"/var/log/network-logs/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?remote-incoming-logs
& ~
EOF

mkdir -p /var/log/network-logs/logs-archive;chown -R root:adm /var/log/network-logs
cat > /etc/logrotate.d/network-logs << EOF
/var/log/network-logs/*.log
{
        size 100M
        copytruncate
        create
        compress
        olddir /var/log/network-logs/logs-archive
        rotate 4
        postrotate
                /usr/lib/rsyslog/rsyslog-rotate
        endscript
}
EOF

rsyslogd -f /etc/rsyslog.conf -N1

rc-update add rsyslog;service rsyslog start
```