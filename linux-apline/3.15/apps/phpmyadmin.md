```sh
apk add --no-cache lighttpd php7 fcgi php7-cgi

mkdir -p /var/www/localhost/htdocs
echo "<?php echo phpinfo(); ?>" > /var/www/localhost/htdocs/info.php

sed -i -r 's#\#.*server.port.*=.*#server.port          = 80#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#.*include "mod_fastcgi.conf".*#\#   include "mod_fastcgi.conf"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd start 
rc-update add lighttpd default

mkdir -p /usr/share/webapps/
cd /usr/share/webapps
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz
tar zxvf phpMyAdmin-5.2.1-all-languages.tar.gz
rm phpMyAdmin-5.2.1-all-languages.tar.gz
mv phpMyAdmin-5.2.1-all-languages phpmyadmin
chmod -R 755 /usr/share/webapps/
ln -s /usr/share/webapps/phpmyadmin/ /var/www/localhost/htdocs/phpmyadmin

CREATE DATABASE phpmyadmin;
GRANT ALL ON phpmyadmin.* TO 'pma'@'127.0.0.1' IDENTIFIED BY 'l<0t@q9k^D!$ko^^im|[0';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON phpmyadmin.* TO 'pma'@'127.0.0.1';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'pma'@'127.0.0.1';

GRANT ALL ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'l<0t@q9k^D!$ko^^im|[0';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON phpmyadmin.* TO 'pma'@'localhost';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'pma'@'localhost';
\q
mysql --user=pma -p phpmyadmin < /usr/share/webapps/phpmyadmin/sql/create_tables.sql
```