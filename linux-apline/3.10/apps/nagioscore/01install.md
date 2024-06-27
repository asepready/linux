lighttpd-mod_auth
apk add --no-cache nagios nagios-web nagios-plugins-all php7-mysqli
apk add --no-cache php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-posix php7-gettext php7-ldap php7-ctype php7-dom php7-simplexml

rm -rf /var/www/localhost/htdocs
ln -s /usr/share/nagios/htdocs/ /var/www/localhost/htdocs/

chown apache:apache /var/www/localhost/htdocs/
chown apache:apache /etc/nagios/