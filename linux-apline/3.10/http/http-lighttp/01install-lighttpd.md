```sh
apk add --no-cache lighttpd

mkdir -p /var/www/localhost/htdocs
sed -i -r 's#\#.*server.port.*=.*#server.port          = 80#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#.*server.stat-cache-engine.*=.*# server.stat-cache-engine = "fam"#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#\#.*server.event-handler = "linux-sysepoll".*#server.event-handler = "linux-sysepoll"#g' /etc/lighttpd/lighttpd.conf

mkdir -p /var/www/localhost/htdocs/serverinfo
sed -i -r 's#\#.*mod_status.*,.*#    "mod_status",#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#.*status.status-url.*=.*#status.status-url  = "/serverinfo/server-status"#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#.*status.config-url.*=.*#status.config-url  = "/serverinfo/server-config"#g' /etc/lighttpd/lighttpd.conf

mkdir -p /var/www/localhost/cgi-bin
sed -i -r 's#\#.*mod_alias.*,.*#    "mod_alias",#g' /etc/lighttpd/lighttpd.conf
sed -i -r 's#.*include "mod_cgi.conf".*#   include "mod_cgi.conf"#g' /etc/lighttpd/lighttpd.conf

mkdir -p /var/lib/lighttpd
chown -R lighttpd:lighttpd /var/www/localhost/
chown -R lighttpd:lighttpd /var/lib/lighttpd
chown -R lighttpd:lighttpd /var/log/lighttpd

rc-update add lighttpd default

rc-service lighttpd restart

checkset="";checkset=$(grep 'noatime' /etc/lighttpd/lighttpd.conf);[[ "$checkset" != "" ]] && \
echo listo || sed -i -r 's#server settings.*#server settings"\nserver.use-noatime = "enable"\n#g' /etc/lighttpd/lighttpd.conf

checkset="";checkset=$(grep 'network-backend' /etc/lighttpd/lighttpd.conf);[[ "$checkset" != "" ]] && \
echo listo || sed -i -r 's#server settings.*#server settings"\nserver.network-backend = "linux-sendfile"\n#g' /etc/lighttpd/lighttpd.conf

checkset="";checkset=$(grep 'max-fds' /etc/lighttpd/lighttpd.conf);[[ "$checkset" != "" ]] && \
echo listo || sed -i -r 's#server settings.*#server settings\nserver.max-fds = 2048\n#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart