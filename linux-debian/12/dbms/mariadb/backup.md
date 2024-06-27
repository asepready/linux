```sh
apk add --no-cache mariadb-backup
mariabackup --backup --target-dir /home/mariadb_backup -u root -p 'wT5?iY2)vO6#aW7&'

# untuk menghapusdata
service mariadb stop && rm -rf /var/lib/mysql

# untuk mempersiapkan backup yang akan direstore
mariabackup --prepare --target-dir /home/mariadb_backup

# untuk melakukan restore
mariabackup --copy-back --target-dir /home/mariadb_backup
chown -R mysql. /var/lib/mysql
service mariadb start

apk add --no-cache php7 php7-fpm php-common php7-cli php7-common php7-json php7-mbstring php7-xml php7-gd php7-curl
