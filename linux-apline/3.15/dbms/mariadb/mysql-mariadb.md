# mariadb-server-default-charset.cnf
```sh
#/etc/my.cnf.d/mariadb-server-default-charset.cnf
[client]
default-character-set = utf8mb4

[mysql]
default-character-set = utf8mb4
```
# mariadb-server-default-highload.cnf
```sh
#/etc/my.cnf.d/mariadb-server-default-highload.cnf

[mysqld]
#skip-networking
bind-address=0.0.0.0
port=3306
#skip-networking
max_allowed_packet = 100M
bind-address=127.0.0.1
character-set-server         = utf8mb4
collation-server             = utf8mb4_unicode_ci
max_heap_table_size          = 512M
tmp_table_size               = 512M
join_buffer_size             = 1024M
innodb_file_format           = Barracuda
innodb_large_prefix          = 1
innodb_buffer_pool_size      = 4000M
innodb_flush_log_at_timeout  = 3
innodb_read_io_threads       = 32
innodb_write_io_threads      = 16
innodb_buffer_pool_instances = 1
innodb_io_capacity           = 5000
innodb_io_capacity_max       = 10000

[mariadb]
max_allowed_packet = 100M
#ssl
ssl-ca = /etc/mysql/ssl/ca-cert.pem
ssl-cert =/etc/mysql/ssl/server-cert.pem
ssl-key = /etc/mysql/ssl/server-key.pem
require-secure-transport = on
## Set up TLS version here. For example TLS version 1.2 and 1.3 ##
tls_version = TLSv1.2,TLSv1.3

[client-mariadb]
## MySQL Client Configuration ##
ssl-ca=/etc/mysql/ssl/ca-cert.pem
ssl-cert=/etc/mysql/ssl/client-cert.pem
ssl-key=/etc/mysql/ssl/client-key.pem
#tls_version = TLSv1.2,TLSv1.3
ssl-verify-server-cert
```