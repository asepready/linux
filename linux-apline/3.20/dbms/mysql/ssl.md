# Referensi
- [MariaDB SSL and secure connections from clients](https://www.cyberciti.biz/faq/how-to-setup-mariadb-ssl-and-secure-connections-from-clients/)(https://www.cyberciti.biz/faq/how-to-setup-mariadb-ssl-and-secure-connections-from-clients/)
- [Securing Connections for Client and Server](https://mariadb.com/kb/en/securing-connections-for-client-and-server/)(https://mariadb.com/kb/en/securing-connections-for-client-and-server/)
# SSL/TLS
- CA common Name : MariaDB-Admin
- Server common Name: MariaDB-Server
- Client common Name: MariaDB-client
```sh
mkdir -p /etc/mysql/ssl;cd /etc/mysql/ssl 
# create a new CA key
openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 365000 -key ca-key.pem -out ca-cert.pem

# Create the server SSL certificate
# create the server key
openssl req -newkey rsa:2048 -days 365000 -nodes -keyout server-key.pem -out server-req.pem
# process the server RSA key
openssl rsa -in server-key.pem -out server-key.pem
# sign the server certificate
openssl x509 -req -in server-req.pem -days 365000 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem

# Create the client SSL certificate
# create the client key
openssl req -newkey rsa:2048 -days 365000 -nodes -keyout client-key.pem -out client-req.pem
# process the client RSA key
openssl rsa -in client-key.pem -out client-key.pem
# sign the client certificate
openssl x509 -req -in client-req.pem -days 365000 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem

# verify the certificates
openssl verify -CAfile ca-cert.pem server-cert.pem client-cert.pem

chown -Rv mysql:root /etc/mysql/ssl/
```
# Verification
Type the mysql command command:
```sh
mysql -u {User-Name-Here} -h {Server-IP-here} -p {DB-Name-Here}
mysql -u root -h 192.168.1.100 -p mysql
mysql -u root -h 127.0.0.1 -p mysql
```
Type the following SHOW VARIABLES LIKE '%ssl%'; command at MariaDB [(none)]> prompt:
```sh
MariaDB [mysql]> SHOW VARIABLES LIKE '%ssl%';
+---------------------+--------------------------------+
| Variable_name       | Value                          |
+---------------------+--------------------------------+
| have_openssl        | YES                            |
| have_ssl            | YES                            |
| ssl_ca              | /etc/mysql/ssl/ca-cert.pem     |
| ssl_capath          |                                |
| ssl_cert            | /etc/mysql/ssl/server-cert.pem |
| ssl_cipher          |                                |
| ssl_crl             |                                |
| ssl_crlpath         |                                |
| ssl_key             | /etc/mysql/ssl/server-key.pem  |
| version_ssl_library | OpenSSL 1.1.1w  11 Sep 2023    |
+---------------------+--------------------------------+
10 rows in set (0.002 sec)
```
OR issue the status command:
```sh
MariaDB [mysql]> status;
--------------
mysql  Ver 15.1 Distrib 10.6.14-MariaDB, for Linux (x86_64) using readline 5.1

Connection id:		6
Current database:	mysql
Current user:		root@localhost
SSL:			Cipher in use is TLS_AES_256_GCM_SHA384
Current pager:		less
Using outfile:		''
Using delimiter:	;
Server:			MariaDB
Server version:		10.6.14-MariaDB MariaDB Server
Protocol version:	10
Connection:		127.0.0.1 via TCP/IP
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	utf8mb4
Conn.  characterset:	utf8mb4
TCP port:		3306
Uptime:			6 min 4 sec

Threads: 1  Questions: 40  Slow queries: 0  Opens: 37  Open tables: 30  Queries per second avg: 0.109
```
Verify SSL vs TLS connections. The following command should fail as ssl 3 is not supported and configured to use:
```sh
openssl s_client -connect 127.0.0.1:3306 -ssl3
140510572795544:error:140A90C4:SSL routines:SSL_CTX_new:null ssl method passed:ssl_lib.c:1878:
```
Check for TLS v 1/1.1/1.2:
```sh
openssl s_client -connect 192.168.1.100:3306 -tls1
openssl s_client -connect 192.168.1.100:3306 -tls1_1
openssl s_client -connect 192.168.1.100:3306 -tls1_2
```