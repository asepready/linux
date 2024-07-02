```sh
apk add php7 fcgi php7-cgi

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