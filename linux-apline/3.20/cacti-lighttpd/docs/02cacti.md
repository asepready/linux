```sh
apk add --no-cache bash attr dialog binutils findutils readline lsof less utmps curl tzdata
ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
export PAGER=less
export MIBS=ALL


## Webserver
sed -i -r 's#\#.*server.port.*=.*#server.port          = 80#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#.*server.stat-cache-engine.*=.*# server.stat-cache-engine = "fam"#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#\#.*server.event-handler = "linux-sysepoll".*#server.event-handler = "linux-sysepoll"#g' /etc/lighttpd/lighttpd.conf

checkset="";checkset=$(grep 'noatime' /etc/lighttpd/lighttpd.conf);[[ "$checkset" != "" ]] && \
echo listo || sed -i -r 's#server settings.*#server settings"\nserver.use-noatime = "enable"\n#g' /etc/lighttpd/lighttpd.conf

checkset="";checkset=$(grep 'network-backend' /etc/lighttpd/lighttpd.conf);[[ "$checkset" != "" ]] && \
echo listo || sed -i -r 's#server settings.*#server settings"\nserver.network-backend = "linux-sendfile"\n#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart

## PHP7-FPM Cacti
apk add --no-cache php7-fpm php7-pear php7-ctype php7-gettext php7-gd php7-gmp php7-json php7-ldap php7-mbstring php7-openssl php7-pdo php7-pdo_mysql php7-mysqli php7-session php7-simplexml php7-sockets php7-xml php7-zlib php7-posix php7-intl php7-pcntl php7-snmp

apk add --no-cache php7-bcmath php7-bz2 php7-curl php7-dom php7-enchant php7-exif php7-iconv php7-imap php7-opcache php7-phar php7-pspell php7-sysvmsg php7-sysvsem php7-sysvshm php7-tidy php7-tokenizer php7-xmlreader php7-xmlrpc php7-xmlwriter php7-xsl php7-zip php7-opcache php7-calendar php7-fileinfo php7-ftp php7-mysqlnd php7-shmop php7-pdo_sqlite php7-sqlite3 php7-odbc php7-pdo_odbc php7-dba

#sed -i -r 's|.*extension_dir =.*|extension_dir = /usr/lib/php7/modules |g' /etc/php*/php.ini
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


mkdir -p /var/run/php-fpm7/;chown lighttpd:root /var/run/php-fpm7

sed -i -r 's|^.*listen =.*|listen = /run/php-fpm7/php7-fpm.sock|g' /etc/php*/php-fpm.d/www.conf

sed -i -r 's|^pid =.*|pid = /run/php-fpm7/php7-fpm.pid|g' /etc/php*/php-fpm.conf

sed -i -r 's#^user =.*#user = lighttpd#g' /etc/php*/php.ini

sed -i -r 's#^group =.*#group = www-data#g' /etc/php*/php.ini

sed -i -r 's|^.*listen.owner =.*|listen.owner = lighttpd|g' /etc/php*/php-fpm.d/www.conf

sed -i -r 's|^.*listen.group =.*|listen.group = www-data|g' /etc/php*/php-fpm.d/www.conf

sed -i -r 's|^.*listen.mode =.*|listen.mode = 0660|g' /etc/php*/php-fpm.d/www.conf

rc-update add php-fpm7;service php-fpm7 restart

sed -i -r 's#.*include "mod_fastcgi.conf".*#\#   include "mod_fastcgi.conf"#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#.*include "mod_fastcgi_fpm.conf".*#   include "mod_fastcgi_fpm.conf"#g' /etc/lighttpd/lighttpd.conf

cat > /etc/lighttpd/mod_fastcgi_fpm.conf << EOF
server.modules += ( "mod_fastcgi" )
fastcgi.server = (
    ".php" => (
      "localhost" => (
        "socket"                => "/var/run/php-fpm7/php7-fpm.sock",
        "broken-scriptfilename" => "enable"
      ))
)
EOF

sed -i -r 's|^.*listen =.*|listen = /var/run/php-fpm7/php7-fpm.sock|g' /etc/php*/php-fpm.d/www.conf

rc-service php-fpm7 restart;rc-service lighttpd restart

echo "<?php echo phpinfo(); ?>" > /var/www/localhost/htdocs/info.php

## SNMP
apk add --no-cache net-snmp net-snmp-tools net-snmp-libs rrdtool

cat > /etc/snmp/snmpd.conf << EOF
view systemonly included .1.3.6.1.2.1.1
view systemonly included .1.3.6.1.2.1.25.1
rocommunity  public localhost
rocommunity  public default -V systemonly
sysLocation    Bolivar Upata Venezuela
sysContact     infoadmin <info@pacificnetwork.com>
sysServices    72
EOF

rc-update add snmpd default;rc-service snmpd restart

## Cacti
apk add --no-cache bash busybox coreutils net-snmp-tools perl rrdtool ttf-dejavu php7-snmp

cat > /etc/lighttpd/mod_cacti.conf << EOF
server.indexfiles += ("index.php")
alias.url += (
     "/cacti"	    =>    "/var/www/cacti/"
)
\$HTTP["url"] =~ "^/cacti" {
    dir-listing.activate = "disable"
}
EOF

sed -i -r 's#\#.*mod_accesslog.*,.*#    "mod_accesslog",#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#\#.*mod_setenv.*,.*#    "mod_setenv",#g' /etc/lighttpd/lighttpd.conf

checkssl="";checkssl=$(grep 'include "mod_cacti.conf' /etc/lighttpd/lighttpd.conf);[[ "$checkssl" != "" ]] && echo listo || sed -i -r 's#.*include "mod_cgi.conf".*#include "mod_cgi.conf"\ninclude "mod_cacti.conf"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart

chown -R cacti:lighttpd /home/cacti/rra/ /home/cacti/log/

sed -i -r 's#\$database_default.*=.*;#\$database_default  = 'cacti';#g' /etc/cacti/config.php

sed -i -r 's#\$database_username.*=.*;#\$database_username  = 'cactiuser';#g' /etc/cacti/config.php

sed -i -r 's#\$database_password.*=.*;#\$database_password  = 'iD0&t6raY768mQ6';#g' /etc/cacti/config.php

mkdir /var/log/cacti;chmod 777 /var/log/cacti;chmod 666 /var/log/cacti/*.log

## Pooler and crontab
cd /etc/crontabs;vi root

# copy to the end of the file:
*/5 * * * * php /home/cacti/poller.php > /dev/null 2>&1

#Plugins

# After extract all of the files, change and fix permissions:
cd /home/cacti/plugins/
chown -R cacti:lighttpd /home/cacti/
chown -R cacti:lighttpd /var/lib/cacti/
