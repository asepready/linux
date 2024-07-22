```sh
CREATE DATABASE cacti;

GRANT ALL ON cacti.* TO 'cactiuser'@'localhost' IDENTIFIED BY 'cactiuser';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'localhost';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';

GRANT ALL ON cacti.* TO 'cactiuser'@'127.0.0.1' IDENTIFIED BY 'cactiuser' REQUIRE SSL;FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'127.0.0.1';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'127.0.0.1';

GRANT ALL ON cacti.* TO 'cactiuser'@'%' IDENTIFIED BY 'cactiuser' REQUIRE SSL;FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'%';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'%';

ALTER USER 'cactiuser'@'localhost' REQUIRE SSL;FLUSH PRIVILEGES;

# Periksa Host yang Diizinkan:
SELECT host FROM mysql.user WHERE user = 'cactiuser';

sed -i -r 's#\$database_default.*=.*;#\$database_default  = 'cacti';#g' /etc/cacti/config.php
sed -i -r 's#\$database_username.*=.*;#\$database_username  = 'cactiuser';#g' /etc/cacti/config.php
sed -i -r 's#\$database_password.*=.*;#\$database_password  = 'cactiuser';#g' /etc/cacti/config.php
\q

mysql --user=cactiuser -p cacti < /usr/share/webapps/cacti/cacti.sql

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
