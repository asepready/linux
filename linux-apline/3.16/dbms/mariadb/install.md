```sh 
apk add --no-cache mysql mysql-client tzdata

mysql_install_db --user=mysql --datadir=/var/lib/mysql

rc-service mariadb start

mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -u root mysql

sed -i "s|.*max_allowed_packet\s*=.*|max_allowed_packet = 100M|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=127.0.0.1|g" /etc/mysql/my.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=127.0.0.1|g" /etc/my.cnf.d/mariadb-server.cnf

cat > /etc/my.cnf.d/charset.cnf << EOF
[client]
default-character-set = utf8mb4

[mysql]
default-character-set = utf8mb4
EOF

cat > /etc/my.cnf.d/mariadb-server-default-highload.cnf << EOF
[mysqld]
character-set-server         = utf8mb4
collation-server             = utf8mb4_general_ci
max_heap_table_size          = 32M
tmp_table_size               = 32M
join_buffer_size             = 62M
innodb_file_format           = Barracuda
innodb_large_prefix          = 1
innodb_buffer_pool_size      = 512M
innodb_flush_log_at_timeout  = 3
innodb_read_io_threads       = 32
innodb_buffer_pool_instances = 1
innodb_io_capacity           = 5000
innodb_io_capacity_max       = 10000
EOF

rc-service mariadb restart
rc-update add mariadb default

apk add --no-cache mariadb-backup
mariabackup --backup --target-dir /home/mariadb_backup -u root -p 'wT5?iY2)vO6#aW7&'

# untuk menghapusdata
service mariadb stop;rm -rf /var/lib/mysql/*

# untuk mempersiapkan backup yang akan direstore
mariabackup --prepare --target-dir /home/mariadb_backup

# untuk melakukan restore
mariabackup --copy-back --target-dir /home/mariadb_backup
chown -R mysql. /var/lib/mysql
service mariadb start