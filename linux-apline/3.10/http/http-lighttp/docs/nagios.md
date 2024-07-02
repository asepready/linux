protecting URL webpage
```sh
apk add lighttpd-mod_auth apache2-utils
htpasswd -c /etc/lighttpd/.htpasswd <Username> #Replace <Username>, you will be prompted to enter the password.

# Make sure that "nagios" is loaded in "server.modules".
cat > /etc/lighttpd/nagios.conf << EOF
server.modules += (
    "mod_cgi",
    "mod_auth",
    "mod_alias"
)
auth.require += ( "/nagios" =>
  (
    "method"  => "digest",
    "realm"   => "nagios",
    "require" => "valid-user"
  )
)

$HTTP["url"] =~ "^/nagios/cgi-bin/" {
  dir-listing.activate = "disable"
  cgi.assign = (
    ".pl"  => "/usr/bin/perl",
    ".cgi" => ""
  )
}

alias.url += (
  "/nagios/cgi-bin" => "/usr/lib/nagios/cgi-bin",
  "/nagios"         => "/usr/share/nagios/htdocs"
)

EOF

#sed -i -r 's#\#.*mod_auth.*,.*#    "mod_auth",#g' /etc/lighttpd/lighttpd.conf

itawxrc="";itawxrc=$(grep 'include "nagios.conf' /etc/lighttpd/lighttpd.conf);[[ "$itawxrc" != "" ]] && echo listo || \
sed -i -r 's#.*include "mod_ssl.conf".*#include "mod_ssl.conf"\ninclude "nagios.conf"#g' /etc/lighttpd/lighttpd.conf

htpasswd /etc/lighttpd/htpasswd nagiosadmin