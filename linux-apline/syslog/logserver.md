## Install Paket
```sh
apk add --no-cache rsyslog rsyslog-mysql
```
## Konfigurasi di /etc/rsyslog.d/mysqldb.conf
aktifkan boot dan jalankan
```sh
mkdir /etc/rsyslog.d;chown -R root:adm /etc/rsyslog.d
cat > /etc/rsyslog.d/network-logs.conf << EOF
#Custom template to generate the log filename dynamically based on the client's IP address or Hostname.
$template remote-incoming-logs,"/var/log/archive/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?remote-incoming-logs
& ~
EOF

mkdir -p /var/log/archive;chown -R root:adm /var/log/archive
cat > /etc/logrotate.d/network-logs << EOF
/var/log/archive/*.log
{
        size 100M
        copytruncate
        create
        compress
        olddir /var/log/archive
        rotate 4
        postrotate
                /usr/lib/rsyslog/rsyslog-rotate
        endscript
}
EOF

adduser syslog --system
rsyslogd -f /etc/rsyslog.conf -N1

rc-update add rsyslog;service rsyslog start
```