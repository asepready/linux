```sh
apk add --no-cache rsyslog rsyslog-mysql

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