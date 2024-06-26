```sh
apk add --no-cache openssl

mkdir -p /etc/ssl/certs/

openssl req -x509 -days 1460 -nodes -newkey rsa:4096 \
   -subj "/C=ID/ST=Bangka-Belitung/L=Pangkalpinang/O=Goverment/OU=Systemas:DISKOMINFO/CN=localhost" \
   -keyout /etc/ssl/certs/localhost.pem -out /etc/ssl/certs/localhost.pem

chmod 755 /etc/ssl/certs/localhost.pem
cat > /etc/lighttpd/mod_ssl.conf << EOF
server.modules += ("mod_openssl")
\$SERVER["socket"] == "0.0.0.0:443" {
    ssl.engine  = "enable"
    ssl.pemfile = "/etc/ssl/certs/localhost.pem"
    ssl.cipher-list = "ECDHE-RSA-AES256-SHA384:AES256-SHA256:RC4:HIGH:!MD5:!aNULL:!EDH:!AESGCM"
    ssl.honor-cipher-order = "enable"
}
\$HTTP["scheme"] == "http" {
    \$HTTP["host"] =~ ".*" {
        url.redirect = (".*" => "https://%0\$0")
    }
}
EOF

sed -i -r 's#\#.*mod_redirect.*,.*#    "mod_redirect",#g' /etc/lighttpd/lighttpd.conf

itawxrc="";itawxrc=$(grep 'include "mod_ssl.conf' /etc/lighttpd/lighttpd.conf);[[ "$itawxrc" != "" ]] && echo listo || \
sed -i -r 's#.*include "mime-types.conf".*#include "mime-types.conf"\ninclude "mod_ssl.conf"#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#ssl.pemfile.*=.*#ssl.pemfile   = "/etc/ssl/certs/localhost.pem"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart
