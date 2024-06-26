```sh
cat > /etc/lighttpd/phpmyadmin.conf << EOF
$HTTP["url"] =~ "^/phpmyadmin($|/)" {
    server.document-root = "/path/to/your/phpmyadmin"
    server.errorlog = "/var/log/lighttpd/phpmyadmin-error.log"
    accesslog.filename = "/var/log/lighttpd/phpmyadmin-access.log"
    
    # Konfigurasi otentikasi dengan file .htpasswd
    auth.backend = "htpasswd"
    auth.backend.htpasswd.userfile = "/path/to/your/.htpasswd"
    auth.require = ( "" => (
        "method" => "basic",
        "realm" => "PhpMyAdmin",
        "require" => "valid-user"
    ))
}
EOF

itawxrc="";itawxrc=$(grep 'include "phpmyadmin.conf' /etc/lighttpd/lighttpd.conf);[[ "$itawxrc" != "" ]] && echo listo || \
sed -i -r 's#.*include "mod_ssl.conf".*#include "mod_ssl.conf"\ninclude "phpmyadmin.conf"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart
