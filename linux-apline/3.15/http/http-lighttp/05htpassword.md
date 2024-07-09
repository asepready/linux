protecting URL webpage
```sh
apk add apache2-utils
htpasswd -c /etc/lighttpd/.htpasswd <Username> #Replace <Username>, you will be prompted to enter the password.

# Make sure that "mod_auth" is loaded in "server.modules".
cat > /etc/lighttpd/mod_auth.conf << EOF
server.modules += ("mod_auth")
auth.backend = "htpasswd"
auth.backend.htpasswd.userfile= "/etc/lighttpd/.htpasswd"
auth.require = ( "/RestrictedURL" => 
    (
    "method"  => "basic",
    "realm"   => "Restricted!",
    "require" => "valid-user"
    ),
)
EOF

sed -i -r 's#\#.*mod_auth.*,.*#    "mod_auth",#g' /etc/lighttpd/lighttpd.conf

itawxrc="";itawxrc=$(grep 'include "mod_auth.conf' /etc/lighttpd/lighttpd.conf);[[ "$itawxrc" != "" ]] && echo listo || \
sed -i -r 's#.*include "mod_ssl.conf".*#include "mod_ssl.conf"\ninclude "mod_auth.conf"#g' /etc/lighttpd/lighttpd.conf

htpasswd /usr/local/nagios/etc/htpasswd.users nagiosadmin