```sh
apk add --no-cache apache2-proxy php7-fpm 

# Cacti
apk add php7-bcmath php7-bz2 php7-ctype php7-curl php7-dom php7-enchant php7-exif php7-gd php7-gettext php7-gmp php7-iconv php7-imap php7-intl php7-json php7-mbstring php7-opcache php7-openssl php7-phar php7-posix php7-pspell php7-session php7-simplexml php7-sockets php7-sysvmsg php7-sysvsem php7-sysvshm php7-tidy php7-tokenizer php7-xml php7-xmlreader php7-xmlrpc php7-xmlwriter php7-xsl php7-zip php7-sqlite3 php7-gd php7-gmp php7-ldap php7-openssl php7-pdo_mysql php7-posix php7-sockets php7-xml

# Cacti Option
apk add php7-pdo php7-pdo_mysql php7-mysqli php7-pdo_sqlite php7-sqlite3 php7-odbc php7-pdo_odbc php7-dba

# Codeigniter
apk add --no-cache php7-curl php7-fileinfo php7-gd php7-iconv php7-json php7-mbstring php7-mysqli php7-mysqlnd php7-tidy php7-zip php7-xml

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

mkdir -p /var/run/php-fpm7/
chown apache:root /var/run/php-fpm7

```

Run and add services to startup
```sh
rc-service php-fpm7 start
rc-update add php-fpm7
rc-service apache2 start
rc-update add apache2
```
Configure
Configure Apache

Uncomment the mpm_event module and comment the mpm_prefork module like so:
```sh
 LoadModule mpm_event_module modules/mod_mpm_event.so
 #LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
```
Add the following lines to /etc/apache2/httpd.conf:
```sh
<FilesMatch \.php$>
    SetHandler "proxy:fcgi://127.0.0.1:9000"
</FilesMatch>
```
Comment out the following lines in /etc/apache2/conf.d/php7-module.conf:
```sh
 #LoadModule php_module modules/mod_php7.so
 
 #DirectoryIndex index.php index.html
 #<FilesMatch \.php$>
 #    SetHandler application/x-httpd-php
 #</FilesMatch>
```
Configure PHP-FPM

Edit the file /etc/php8/php-fpm.conf to suit your needs.

In the configuration you may need to change the default user and group from nobody to another user such as apache:
```sh
sed -i -r 's#^user =.*#user = apache#g' /etc/php*/php.ini
sed -i -r 's#^group =.*#group = apache#g' /etc/php*/php.ini
sed -i -r 's|^.*listen.owner =.*|listen.owner = apache|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*listen.group =.*|listen.group = apache|g' /etc/php*/php-fpm.d/www.conf
sed -i -r 's|^.*listen.mode =.*|listen.mode = 0660|g' /etc/php*/php-fpm.d/www.conf
```
Restart apache2 and PHP-FPM after editing the configuration:
```sh
# rc-service php-fpm7 reload && rc-service apache2 reload
```
echo "<?php echo phpinfo(); ?>" > /var/www/localhost/htdocs/info.php