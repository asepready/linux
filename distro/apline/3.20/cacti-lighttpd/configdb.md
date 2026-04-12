```sh
CREATE DATABASE cactidb;

GRANT ALL ON cactidb.* TO 'cactiuser'@'localhost' IDENTIFIED BY 'cactipass';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cactidb.* TO 'cactiuser'@'localhost';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';

GRANT ALL ON cactidb.* TO 'cactiuser'@'127.0.0.1' IDENTIFIED BY 'cactipass' REQUIRE SSL;FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cactidb.* TO 'cactiuser'@'127.0.0.1';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'127.0.0.1';

GRANT ALL ON cactidb.* TO 'cactiuser'@'%' IDENTIFIED BY 'cactipass' REQUIRE SSL;FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cactidb.* TO 'cactiuser'@'%';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'%';

ALTER USER 'cactiuser'@'localhost' REQUIRE SSL;FLUSH PRIVILEGES;

# Periksa Host yang Diizinkan:
SELECT host FROM mysql.user WHERE user = 'cactiuser';

sed -i -r 's#\$database_default.*=.*;#\$database_default  = 'cactidb';#g' /etc/cacti/config.php
sed -i -r 's#\$database_username.*=.*;#\$database_username  = 'cactiuser';#g' /etc/cacti/config.php
sed -i -r 's#\$database_password.*=.*;#\$database_password  = 'cactipass';#g' /etc/cacti/config.php
\q

mysql --user=cactiuser -p cactidb < /usr/share/webapps/cacti/cacti.sql

mysql -u cactiuser -h localhost -p --ssl
```

/etc/cacti/config.php

```sh
$database_type     = 'mysql';
$database_default  = 'cacti';
$database_hostname = 'localhost';
$database_username = 'cactiuser';
$database_password = 'cactiuser';
$database_port     = '3306';
$database_retries  = 5;


//$scripts_path = '/var/www/html/cacti/scripts';
//$resource_path = '/var/www/html/cacti/resource/';
```
