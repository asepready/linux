```sh
CREATE DATABASE cacti;

GRANT ALL ON cacti.* TO 'cactiuser'@'localhost' IDENTIFIED BY 'iD0&t6raY768mQ6';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'localhost';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';


# Periksa Host yang Diizinkan:
SELECT host FROM mysql.user WHERE user = 'cactiuser';

sed -i -r 's#\$database_default.*=.*;#\$database_default  = 'cacti';#g' /etc/cacti/config.php
sed -i -r 's#\$database_username.*=.*;#\$database_username  = 'cactiuser';#g' /etc/cacti/config.php
sed -i -r 's#\$database_password.*=.*;#\$database_password  = 'iD0&t6raY768mQ6';#g' /etc/cacti/config.php
\q
mysql --user=cactiuser -p cacti < /usr/share/webapps/cacti/cacti.sql
mysql -u cactiuser -h 192.168.10.4 -p

```