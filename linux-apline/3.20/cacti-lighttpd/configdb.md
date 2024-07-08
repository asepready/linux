```sh
CREATE DATABASE cacti;

GRANT ALL ON cacti.* TO 'cactiuser'@'localhost' IDENTIFIED BY 'iD0&t6raY768mQ6';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'localhost';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';

GRANT ALL ON cacti.* TO 'cactiuser'@'127.0.0.1' IDENTIFIED BY 'iD0&t6raY768mQ6' REQUIRE SSL;FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'127.0.0.1';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'127.0.0.1';

ALTER USER 'cactiuser'@'localhost' REQUIRE SSL;FLUSH PRIVILEGES;

# Periksa Host yang Diizinkan:
SELECT host FROM mysql.user WHERE user = 'cactiuser';

sed -i -r 's#\$database_default.*=.*;#\$database_default  = 'cacti';#g' /etc/cacti/config.php
sed -i -r 's#\$database_username.*=.*;#\$database_username  = 'cactiuser';#g' /etc/cacti/config.php
sed -i -r 's#\$database_password.*=.*;#\$database_password  = 'iD0&t6raY768mQ6';#g' /etc/cacti/config.php
\q

mysql --user=cactiuser -p cacti < /usr/share/webapps/cacti/cacti.sql

mysql -u cactiuser -h 192.168.20.4 -p --ssl
```
/etc/cacti/config.php
```sh
$database_type     = 'mysql';                                               
$database_default  = 'cacti';                                               
$database_hostname = '192.168.20.4';                                        
$database_username = 'cactiuser';                                           
$database_password = 'iD0&t6raY768mQ6';                                     
$database_port     = '3306';                                                
$database_retries  = 5;   
$database_ssl      = true;
$database_ssl_key  = '/etc/mysql/ssl/client-key.pem';
$database_ssl_cert = '/etc/mysql/ssl/client-cert.pem';
$database_ssl_ca   = '/etc/mysql/ssl/ca-cert.pem';


//$scripts_path = '/var/www/html/cacti/scripts';                            
//$resource_path = '/var/www/html/cacti/resource/';
```
