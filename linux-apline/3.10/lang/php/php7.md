apk add --no-cache php7-fpm php7-bcmath php7-bz2 php7-ctype php7-curl php7-dom php7-enchant php7-exif php7-gd php7-gettext php7-gmp php7-iconv php7-imap php7-intl php7-json php7-mbstring php7-opcache php7-openssl php7-phar php7-posix php7-pspell php7-session php7-simplexml php7-sockets php7-sysvmsg php7-sysvsem php7-sysvshm php7-tidy php7-tokenizer php7-xml php7-xmlreader php7-xmlrpc php7-xmlwriter php7-xsl php7-zip php7-sqlite3 php7-gd php7-gmp php7-ldap php7-openssl php7-pdo_mysql php7-posix php7-sockets php7-xml

# php74
```sh
apk add --no-cache php7-fpm php7-bcmath php7-brotli php7-bz2 php7-calendar php7-cgi php7-common php7-ctype php7-curl php7-dba php7-dbg php7-dom php7-embed php7-enchant php7-exif php7-ffi php7-fileinfo php7-ftp php7-gd php7-gettext php7-gmp php7-iconv php7-imap php7-intl php7-json php7-ldap php7-litespeed php7-mbstring php7-mysqli php7-mysqlnd php7-odbc php7-opcache php7-openssl php7-pcntl php7-pdo php7-pdo_dblib php7-pdo_mysql php7-pdo_odbc php7-pdo_pgsql php7-pdo_sqlite php7-pear php7-pecl-amqp php7-pecl-apcu php7-pecl-ast php7-pecl-couchbase php7-pecl-event php7-pecl-gmagick php7-pecl-igbinary php7-pecl-imagick php7-pecl-imagick php7-pecl-lzf php7-pecl-mailparse php7-pecl-maxminddb php7-pecl-mcrypt php7-pecl-memcache php7-pecl-memcached php7-pecl-mongodb php7-pecl-msgpack php7-pecl-oauth php7-pecl-protobuf php7-pecl-psr php7-pecl-rdkafka php7-pecl-redis php7-pecl-ssh2 php7-pecl-timezonedb php7-pecl-uploadprogress php7-pecl-uploadprogress php7-pecl-uuid php7-pecl-vips php7-pecl-xdebug php7-pecl-xhprof php7-pecl-xhprof-assets php7-pecl-yaml php7-pecl-zmq php7-pecl-zstd php7-pgsql php7-phalcon php7-phar php7-phpdbg php7-posix php7-pspell php7-session php7-shmop php7-simplexml php7-snmp php7-soap php7-sockets php7-sodium php7-sqlite3 php7-sysvmsg php7-sysvsem php7-sysvshm php7-tideways_xhprof php7-tidy php7-tokenizer php7-xml php7-xmlreader php7-xmlrpc php7-xmlwriter php7-xsl php7-zip php7 php7-apache2 php7-dev php7-doc  
```
```sh
sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php82/php-fpm.d/www.conf #uncommenting line

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
sed -i -r 's#.*date.timezone =.*#date.timezone = Asia/Jakarta' /etc/php*/php.ini
```
