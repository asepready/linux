```sh
apk add lighttpd-mod_auth apache2-utils
cat > /etc/lighttpd/mod_auth.conf << EOF
server.modules += ("mod_auth")
auth.backend = "htpasswd"
auth.backend.htpasswd.userfile= "/etc/lighttpd/htpasswd"
auth.require = ( "/nagios" => 
    (
    "method"  => "basic",
    "realm"   => "nagios",
    "require" => "valid-user"
    ),
)
EOF
