```sh
# Standart
apk add --no-cache php7 fcgi php7-cgi

# Require Cacti
apk add --no-cache php7-pear php7-ctype php7-gettext php7-gd php7-gmp php7-json php7-ldap php7-mbstring php7-openssl php7-pdo php7-pdo_mysql php7-session php7-simplexml php7-sockets php7-xml php7-zlib php7-posix

sed -i -r 's#.*include "mod_fastcgi.conf".*#\#   include "mod_fastcgi.conf"#g' /etc/lighttpd/lighttpd.conf

cat > /etc/lighttpd/mod_fastcgi.conf << EOF
server.modules += ("mod_fastcgi")
fastcgi.server = ( ".php" =>
		            ( "localhost" =>
			            (
				            "socket"		=>		"/run/lighttpd/lighttpd-fastcgi-php-" + PID + ".socket",
				            "bin-path"	=>		"/usr/bin/php-cgi7"
			            )
		            )
	            )
EOF

rc-service lighttpd restart
echo "<?php echo phpinfo(); ?>" > /var/www/localhost/htdocs/info.php