```sh
# Packages
rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-6.0-4.el8.noarch.rpm
dnf clean all

dnf install zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent

dnf install mariadb-server

# database
mysql -uroot -p
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by 'password';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
\q;

# Zabbix server host import initial schema and data.
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix

# Disable log_bin_trust_function_creators option after importing database schema
mysql -uroot -p
set global log_bin_trust_function_creators = 0;
\q;

# Edit file /etc/zabbix/zabbix_server.conf
DBPassword=password

# Edit file /etc/nginx/conf.d/zabbix.conf
listen 8080;
server_name example.com;

# Start
systemctl restart zabbix-server zabbix-agent nginx php-fpm
systemctl enable zabbix-server zabbix-agent nginx php-fpm