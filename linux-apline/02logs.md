# Layanan Logs Central (Rsyslog)
https://wiki.alpinelinux.org/wiki/Production_LAMP_system:_Lighttpd_+_PHP_+_MySQL
## Install Paket
```sh
apk add --no-cache rsyslog rsyslog-mysql
```
## Konfigurasi di /etc/rsyslog.conf
```
*.* :ommysql:localhost,Syslog,sysloguser,syslogpassword

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

$ModLoad ommysql 
*.* :ommysql:localhost,Syslog,root,[passwordDatabase]
```
aktifkan boot dan jalankan
```sh
rc-update add rsyslog
service rsyslog start
```