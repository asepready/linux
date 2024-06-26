```sh
CREATE DATABASE cacti;

GRANT ALL ON cacti.* TO 'cactiuser'@'localhost' IDENTIFIED BY 'iDAS&S6:oP8mQ6*';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'localhost';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';

GRANT ALL ON cacti.* TO 'cactiuser'@'mysql.pangkalpinangkota.go.id' IDENTIFIED BY 'iDAS&S6:oP8mQ6*';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'mysql.pangkalpinangkota.go.id';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'mysql.pangkalpinangkota.go.id';

GRANT ALL ON cacti.* TO 'cactiuser'@'192.168.10.4' IDENTIFIED BY 'iDAS&S6:oP8mQ6*';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'192.168.10.4';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'192.168.10.4';

GRANT ALL ON cacti.* TO 'cactiuser'@'' IDENTIFIED BY 'iDAS&S6:oP8mQ6*';FLUSH PRIVILEGES;
GRANT GRANT OPTION ON cacti.* TO 'cactiuser'@'';FLUSH PRIVILEGES;
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'';

# Periksa Host yang Diizinkan:
SELECT host FROM mysql.user WHERE user = 'cactiuser';

# Izinkan Akses dari Host Jarak Jauh

\q
mysql --user=cactiuser -p cacti < /usr/share/webapps/cacti/cacti.sql
mysql -u cactiuser -h 192.168.10.4 -p
```