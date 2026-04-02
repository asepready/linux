```sh
apk add acl bash curl fping git graphviz imagemagick mariadb mariadb-client mtr nginx nmap php83-cli php83-curl php83-fpm php83-gd php83-gmp php83-json php83-mbstring php83-mysqli php83-mysqlnd php83-snmp php83-xml php83-zip python3 rrdtool net-snmp net-snmp-tools traceroute unzip whois

apk add php83-pdo php83-session php83-simplexml php83-sockets php83-dom php83-fileinfo php83-tokenizer

adduser librenms -d /opt/librenms -M -r -s "$(which bash)"

git clone https://github.com/librenms/librenms.git

chown -R librenms:librenms /opt/librenms
chmod 771 /opt/librenms
setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/

su - librenms
./scripts/composer_wrapper.php install --no-dev
exit
```
