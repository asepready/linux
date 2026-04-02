```sh
apk add bash attr dialog binutils findutils readline lsof less utmps curl tzdata
ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

export PAGER=less
export MIBS=ALL

## PHP83-FPM Cacti
apk add cacti cacti-lang cacti-setup cacti-php
apk add bash busybox coreutils net-snmp-tools perl rrdtool ttf-dejavu php83-snmp

apk add php83-fpm

# Require Cacti
apk add php83-pear php83-ctype php83-gettext php83-gd php83-gmp php83-json php83-ldap php83-mbstring php83-openssl php83-pdo php83-pdo_mysql php83-mysqli php83-session php83-simplexml php83-sockets php83-xml php83-zlib php83-posix php83-intl php83-pcntl php83-snmp

apk add php83-bcmath php83-bz2 php83-curl php83-dom php83-enchant php83-exif php83-iconv php83-imap php83-opcache php83-phar php83-pspell php83-sysvmsg php83-sysvsem php83-sysvshm php83-tidy php83-tokenizer php83-xmlreader php83-xmlwriter php83-xsl php83-zip php83-opcache php83-calendar php83-fileinfo php83-ftp php83-mysqlnd php83-shmop php83-pdo_sqlite php83-sqlite3 php83-odbc php83-pdo_odbc php83-dba

#sed -i -r 's|.*extension_dir =.*|extension_dir = /usr/lib/php83/modules |g' /etc/php*/php.ini
sed -i -r 's|.*cgi.fix_pathinfo=.*|cgi.fix_pathinfo=1|g' /etc/php*/php.ini
sed -i -r 's#.*safe_mode =.*#safe_mode = Off#g' /etc/php*/php.ini
sed -i -r 's#.*expose_php =.*#expose_php = Off#g' /etc/php*/php.ini
sed -i -r 's#memory_limit =.*#memory_limit = 512M#g' /etc/php*/php.ini
sed -i -r 's#upload_max_filesize =.*#upload_max_filesize = 56M#g' /etc/php*/php.ini
sed -i -r 's#post_max_size =.*#post_max_size = 128M#g' /etc/php*/php.ini
sed -i -r 's#^file_uploads =.*#file_uploads = On#g' /etc/php*/php.ini
sed -i -r 's#^max_file_uploads =.*#max_file_uploads = 12#g' /etc/php*/php.ini
sed -i -r 's#^allow_url_fopen = .*#allow_url_fopen = On#g' /etc/php*/php.ini
sed -i -r 's#^.default_charset =.*#default_charset = "UTF-8"#g' /etc/php*/php.ini
sed -i -r 's#^.max_execution_time =.*#max_execution_time = 90#g' /etc/php*/php.ini
sed -i -r 's#^max_input_time =.*#max_input_time = 90#g' /etc/php*/php.ini
sed -i -r 's#.*date.timezone =.*#date.timezone = Asia/Jakarta#g' /etc/php*/php.ini

sed -i -r 's|.*events.mechanism =.*|events.mechanism = epoll|g' /etc/php*/php-fpm.conf
sed -i -r 's|.*emergency_restart_threshold =.*|emergency_restart_threshold = 12|g' /etc/php*/php-fpm.conf
sed -i -r 's|.*emergency_restart_interval =.*|emergency_restart_interval = 1m|g' /etc/php*/php-fpm.conf
sed -i -r 's|.*process_control_timeout =.*|process_control_timeout = 8s|g' /etc/php*/php-fpm.conf

sed -i -r 's|^.*pm.max_requests =.*|pm.max_requests = 10000|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*pm.max_children =.*|pm.max_children = 12|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*pm.start_servers =.*|pm.start_servers = 4|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*pm.min_spare_servers =.*|pm.min_spare_servers = 4|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*pm.max_spare_servers =.*|pm.max_spare_servers = 8|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*pm.process_idle_timeout =.*|pm.process_idle_timeout = 8s|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*pm =.*|pm = ondemand|g' /etc/php*/php-fpm.d/www.conf

sed -i -r 's|^.*listen =.*|listen = /run/php-fpm83/php83-fpm.sock|g' /etc/php*/php-fpm.d/www.conf

sed -i -r 's|^pid =.*|pid = /run/php-fpm83/php83-fpm.pid|g' /etc/php*/php-fpm.conf

sed -i -r 's#^user =.*#user = cacti#g' /etc/php*/php.ini
sed -i -r 's#^group =.*#group = lighttpd#g' /etc/php*/php.ini

sed -i -r 's|^.*listen.owner =.*|listen.owner = cacti|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*listen.group =.*|listen.group = lighttpd|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*listen.mode =.*|listen.mode = 0660|g' /etc/php*/php-fpm.d/www.conf

rc-update add php-fpm83;service php-fpm83 restart


## SNMP
apk add net-snmp net-snmp-tools net-snmp-libs rrdtool

cat > /etc/snmp/snmpd.conf << EOF
view systemonly included .1.3.6.1.2.1.1
view systemonly included .1.3.6.1.2.1.25.1
rocommunity  public localhost
rocommunity public default -V systemonly
sysLocation Bolivar Upata Venezuela
sysContact  infoadmin <info@asepready.id>
sysServices 72
EOF

rc-update add snmpd default;rc-service snmpd restart


chown -R cacti:lighttpd /usr/share/webapps/cacti/ /var/lib/cacti/
chmod 666 /var/log/cacti/*.log

## Pooler and crontab
cd /etc/crontabs;vi root

# copy to the end of the file:
*/5 * * * * php /usr/share/webapps/cacti/poller.php > /dev/null 2>&1

#Plugins
cd /usr/share/webapps/cacti/plugins/

```
