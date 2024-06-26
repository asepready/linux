```sh
apk add --no-cache php82-fpm php82-bcmath php82-bz2 php82-ctype php82-curl php82-dom php82-enchant php82-exif php82-gd php82-gettext php82-gmp php82-iconv php82-imap php82-intl php82-json php82-mbstring php82-opcache php82-openssl php82-phar php82-posix php82-pspell php82-session php82-simplexml php82-sockets php82-sysvmsg php82-sysvsem php82-sysvshm php82-tidy php82-tokenizer php82-xml php82-xmlreader php82-xmlrpc php82-xmlwriter php82-xsl php82-zip php82-sqlite3 php82-gd php82-gmp php82-ldap php82-openssl php82-pdo_mysql php82-posix php82-sockets php82-xml

apk add php82-pdo php82-pdo_mysql php82-mysqli php82-pdo_sqlite php82-sqlite3 php82-odbc php82-pdo_odbc php82-dba

# Codeigniter
apk add --no-cache php82-curl php82-fileinfo php82-gd php82-iconv php82-json php82-mbstring php82-mysqli php82-mysqlnd php82-tidy php82-zip php82-xml

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

mkdir -p /var/run/php-fpm82/
chown lighttpd:root /var/run/php-fpm82

sed -i -r 's|^.*listen =.*|listen = /run/php-fpm82/php82-fpm.sock|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^pid =.*|pid = /run/php-fpm82/php82-fpm.pid|g' /etc/php*/php-fpm.conf
sed -i -r 's#^user =.*#user = lighttpd#g' /etc/php*/php.ini
sed -i -r 's#^group =.*#group = lighttpd#g' /etc/php*/php.ini
sed -i -r 's|^.*listen.owner =.*|listen.owner = lighttpd|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*listen.group =.*|listen.group = lighttpd|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*listen.mode =.*|listen.mode = 0660|g' /etc/php*/php-fpm.d/www.conf

rc-update add php-fpm82 default
service php-fpm82 restart


mkdir -p /var/www/localhost/cgi-bin
sed -i -r 's#\#.*mod_alias.*,.*#    "mod_alias",#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#.*include "mod_cgi.conf".*#   include "mod_cgi.conf"#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#.*include "mod_fastcgi.conf".*#\#   include "mod_fastcgi.conf"#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#.*include "mod_fastcgi_fpm.conf".*#   include "mod_fastcgi_fpm.conf"#g' /etc/lighttpd/lighttpd.conf

cat > /etc/lighttpd/mod_fastcgi_fpm.conf << EOF
server.modules += ( "mod_fastcgi" )
index-file.names += ( "index.php" )
fastcgi.server = (
    ".php" => (
      "localhost" => (
        "socket"                => "/var/run/php-fpm82/php82-fpm.sock",
        "broken-scriptfilename" => "enable"
      ))
)
EOF

sed -i -r 's|^.*listen =.*|listen = /var/run/php-fpm82/php82-fpm.sock|g' /etc/php*/php-fpm.d/www.conf

rc-service php-fpm82 restart
rc-service lighttpd restart

echo "<?php echo phpinfo(); ?>" > /var/www/localhost/htdocs/info.php