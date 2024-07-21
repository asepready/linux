```sh
apk add bash attr dialog binutils findutils readline lsof less utmps curl tzdata
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

## PHP82-FPM Cacti
apk add cacti cacti-lang cacti-setup cacti-php8
apk add bash busybox coreutils net-snmp-tools perl rrdtool ttf-dejavu php82-snmp

apk add php82-fpm

# Require Cacti
apk add php82-pear php82-ctype php82-gettext php82-gd php82-gmp php82-json php82-ldap php82-mbstring php82-openssl php82-pdo php82-pdo_mysql php82-mysqli php82-session php82-simplexml php82-sockets php82-xml php82-zlib php82-posix php82-intl php82-pcntl php82-snmp

apk add php82-bcmath php82-bz2 php82-curl php82-dom php82-enchant php82-exif php82-iconv php82-imap php82-opcache php82-phar php82-pspell php82-sysvmsg php82-sysvsem php82-sysvshm php82-tidy php82-tokenizer php82-xmlreader php82-xmlwriter php82-xsl php82-zip php82-opcache php82-calendar php82-fileinfo php82-ftp php82-mysqlnd php82-shmop php82-pdo_sqlite php82-sqlite3 php82-odbc php82-pdo_odbc php82-dba

#sed -i -r 's|.*extension_dir =.*|extension_dir = /usr/lib/php82/modules |g' /etc/php*/php.ini
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


mkdir -p /var/run/php-fpm82/;chown lighttpd:root /var/run/php-fpm82

sed -i -r 's|^.*listen =.*|listen = /run/php-fpm82/php82-fpm.sock|g' /etc/php*/php-fpm.d/www.conf

sed -i -r 's|^pid =.*|pid = /run/php-fpm82/php82-fpm.pid|g' /etc/php*/php-fpm.conf


sed -i -r 's#^user =.*#user = cacti#g' /etc/php*/php.ini

sed -i -r 's#^group =.*#group = lighttpd#g' /etc/php*/php.ini

sed -i -r 's|^.*listen.owner =.*|listen.owner = cacti|g' /etc/php*/php-fpm.d/www.conf

sed -i -r 's|^.*listen.group =.*|listen.group = lighttpd|g' /etc/php*/php-fpm.d/www.conf

sed -i -r 's|^.*listen.mode =.*|listen.mode = 0660|g' /etc/php*/php-fpm.d/www.conf

rc-update add php-fpm82;service php-fpm82 restart



sed -i -r 's#.*include "mod_fastcgi.conf".*#\#   include "mod_fastcgi.conf"#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#.*include "mod_fastcgi_fpm.conf".*#   include "mod_fastcgi_fpm.conf"#g' /etc/lighttpd/lighttpd.conf

cat > /etc/lighttpd/mod_fastcgi_fpm.conf << EOF
server.modules += ( "mod_fastcgi" )
fastcgi.server = (
    ".php" => (
      "localhost" => (
        "socket"                => "/var/run/php-fpm82/php82-fpm.sock",
        "broken-scriptfilename" => "enable"
      ))
)
EOF

sed -i -r 's|^.*listen =.*|listen = /var/run/php-fpm82/php82-fpm.sock|g' /etc/php*/php-fpm.d/www.conf

rc-service php-fpm82 restart;rc-service lighttpd restart

echo "<?php echo phpinfo(); ?>" > /var/www/localhost/htdocs/info.php

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

## Cacti
cat > /etc/lighttpd/mod_cacti.conf << EOF
alias.url += (
     "/cacti"	    =>    "/usr/share/webapps/cacti/"
)
\$HTTP["url"] =~ "^/cacti/" {
    dir-listing.activate = "disable"
}
EOF

sed -i -r 's#\#.*mod_accesslog.*,.*#    "mod_accesslog",#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#\#.*mod_setenv.*,.*#    "mod_setenv",#g' /etc/lighttpd/lighttpd.conf

checkssl="";checkssl=$(grep 'include "mod_cacti.conf' /etc/lighttpd/lighttpd.conf);[[ "$checkssl" != "" ]] && echo listo || sed -i -r 's#.*include "mod_cgi.conf".*#include "mod_cgi.conf"\ninclude "mod_cacti.conf"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart

sed -i -r 's#\$database_default.*=.*;#\$database_default  = 'cacti';#g' /etc/cacti/config.php

sed -i -r 's#\$database_username.*=.*;#\$database_username  = 'cactiuser';#g' /etc/cacti/config.php

sed -i -r 's#\$database_password.*=.*;#\$database_password  = 'cactiuser';#g' /etc/cacti/config.php


chown -R cacti:lighttpd /usr/share/webapps/cacti/ /var/lib/cacti/
chmod 666 /var/log/cacti/*.log

## Pooler and crontab
cd /etc/crontabs;vi root

# copy to the end of the file:
*/5 * * * * php /usr/share/webapps/cacti/poller.php > /dev/null 2>&1

#Plugins
cd /usr/share/webapps/cacti/plugins/

