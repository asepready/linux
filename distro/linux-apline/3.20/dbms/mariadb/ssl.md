- CA common Name : MariaDB admin
- Server common Name: MariaDB server
- Client common Name: MariaDB client
```sh
mkdir -p /etc/mysql/ssl && cd /etc/mysql/ssl 
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