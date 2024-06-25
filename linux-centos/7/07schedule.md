## Layanan Penjadwal Backup dengan Cron & NTP(Network Time Protocol)
## Install NTP Packages
```sh
yum install -y ntp
```
## Configure NTP Servers
vi /etc/ntp.conf
```sh
....
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst
server 0.id.pool.ntp.org iburst
server 1.id.pool.ntp.org iburst
server 2.id.pool.ntp.org iburst
server 3.id.pool.ntp.org iburst
```

```sh
systemctl enable ntpd && systemctl start ntpd && systemctl status ntpd
ntpq -p
timedatectl set-timezone Asia/Jakarta
```

## client set time

```sh 
timedatectl
timedatectl set-ntp n #
timedatectl set-time 12:49:00 #manual set
timedatectl set-timezone Asia/Jakarta
timedatectl set-ntp on #sin
```

### konfigurasi crontab untuk backup sysadmin
konfigurasi crontab untuk penjadwalan backup “sysadmin” otomatis yang dilakukan tiap tanggal 1 pada jam 09.00 pagi di setiap bulan.
```sh file
crontab –e #Perintah Terminal

#/tmp/crontab.gxrr2q/crontab
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
# m h dom mon dow command

# konfigurasi backup web
0 9 1 * * tar -zcf /home/sysadmin/backup/"abcnet_wordpress.$(date '+\%d-\%m-\%Y-\%H.\%M.\%S').tar.gz" /home/sysadmin/web
# konfigurasi backup database
0 9 1 * * mysqldump -u abcnet -p123456 abcnet_wordpress > /home/sysadmin/backup/"abcnet_wordpress.$(date '+\%d-\%m-\%Y-\%H.\%M.\%S').sql"
```

service cron restart