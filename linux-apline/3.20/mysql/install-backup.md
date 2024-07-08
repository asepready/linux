```sh 
apk add --no-cache mysql mysql-client tzdata
ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
mysql_install_db --user=mysql --datadir=/var/lib/mysql

rc-service mariadb start

mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -u root mysql

rc-service mariadb restart
rc-update add mariadb default

apk add --no-cache mariadb-backup

#-------------------Backup root tanpa password & SSL
mariabackup --backup --target-dir /home/mariadb_backup -u root
# untuk menghapusdata
service mariadb stop;rm -rf /var/lib/mysql/*
# untuk mempersiapkan backup yang akan direstore
mariabackup --prepare --target-dir /home/mariadb_backup
# untuk melakukan restore
mariabackup --copy-back --target-dir /home/mariadb_backup
chown -R mysql. /var/lib/mysql
service mariadb start