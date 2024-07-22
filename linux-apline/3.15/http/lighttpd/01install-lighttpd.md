# Lighttpd Installation
This production environment will handle only the necessary packages... so no doc or manpages allowed.
- make the htdocs public web root directories
- added the service to the default runlevel, not to boot, because need networking activated
- start the web server service
```sh
apk add lighttpd
mkdir -p /var/www/html /var/lib/lighttpd; chown -R lighttpd:lighttpd /var/www/html /var/lib/lighttpd
rc-update add lighttpd default;rc-service lighttpd restart
echo "it works" > /var/www/html/index.html
```
# Lighttpd Configuration
## Status page
Taking care of the status web server: those special pages are just minimal info of the running web server, are need to view from outside in a case of emergency, do not take the wrong approach of hide behind a filtered ip or filtered network, you must have access in all time in all the web to see problems.`mod_status`
- Enable the mod_status at the config files
- change path in the config file (optional), we are using security by obfuscation
- restart the service to see changes at the browser
```sh
sed -i -r 's#\#.*mod_status.*,.*#    "mod_status",#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#.*status.status-url.*=.*#status.status-url  = "/server-status"#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#.*status.config-url.*=.*#status.config-url  = "/server-config"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart
```

## CGI bin directory support
By default packages assign a directory under localhost main domain, other linux uses a global cgi directory and aliasing.. the most professional way, but think about it, this per domain configuration allows isolation:`mod_cgi`
1. enable the mod_alias at the config file, due need of a specific path for cgi files into security
2. create the directory
3. enable the config cgi file
4. restart the service to see changes at the browser
```sh
mkdir -p /var/www/cgi-bin

cat > /etc/lighttpd/mod_cgi.conf << EOF
server.modules += ("mod_cgi")
alias.url = (
    "/cgi-bin" =>	var.basedir + "/cgi-bin/"
)

$HTTP["url"] =~ "^/cgi-bin/" {
    dir-listing.activate = "disable"
    cgi.assign = (
        ".pl"	=>	"/usr/bin/perl",
        ".cgi"	=>	"/usr/bin/perl"
    )
}
EOF

sed -i -r 's#\#.*mod_alias.*,.*#    "mod_alias",#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#.*include "mod_cgi.conf".*#   include "mod_cgi.conf"#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#.*dir-listing.activate.*=.*#dir-listing.activate  = "enable"#g' /etc/lighttpd/lighttpd.conf

echo "cgi it works" > /var/www/cgi-bin/index.html

rc-service lighttpd restart
```
## Make special errors (404 or 500) pages for clients and visitors
These pages will be shown to visitors when a page or path is not present on the server, or when an internal error happens. These replace the default, minimal error pages and can be a nice message or "away from here" message:`server.errorfile-prefix`
```sh
mkdir -p /var/www/errors

cat > /var/www/errors/status-404.html << EOF
<h1>The page that you requested are not yet here anymore, sorry was moved or updated, search or visit another one</h1>
EOF

cat > /var/www/errors/status-500.html << EOF
<h1>Please wait a moment, there's something happens and we are give support maintenance right now to resolve</h1>
EOF

cp /var/www/errors/status-404.html /var/www/errors/status-403.html

cp /var/www/errors/status-500.html /var/www/errors/status-501.html

cp /var/www/errors/status-500.html /var/www/errors/status-503.html

sed -i -r 's#.*server.errorfile-prefix.*#server.errorfile-prefix    = var.basedir + "/errors/status-"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart
``` 
## Lighttpd SSL support
Create TLS configuration for lighttpd. Best way to do that is by external include files. Debian counterpart has a good mechanism that enables configuration files. We will add SSL support in a similar way.
SSL : making self signed certificate</br>
We need to created a self-signed certificate if we do not already have one:
1. install openssl
2. create the self signed certificate
3. set proper permissions
4. create a SSL module configuration file for lighttpd
5. activate the openssl module missing from config file
6. activate the mod_redirect in case of global http to https redirections
7. restart the service to see changes
```sh
apk add openssl

mkdir -p /etc/ssl/certs/
openssl req -x509 -days 1460 -nodes -newkey rsa:4096 \
   -subj "/C=ID/ST=Bangka-Belitung/L=Pangkalpinang/O=Goverment/OU=Systemas:DISKOMINFO/CN=localhost" \
   -keyout /etc/ssl/certs/localhost.pem -out /etc/ssl/certs/localhost.pem

chmod 400 /etc/ssl/certs/localhost.pem

cat > /etc/lighttpd/mod_ssl.conf << EOF
server.modules += ("mod_openssl")
\$SERVER["socket"] == "0.0.0.0:443" {
    ssl.engine  = "enable"
    ssl.pemfile = "/etc/ssl/certs/localhost.pem"
    ssl.cipher-list = "ECDHE-RSA-AES256-SHA384:AES256-SHA256:RC4:HIGH:!MD5:!aNULL:!EDH:!AESGCM"
    ssl.honor-cipher-order = "enable"
}
\$HTTP["scheme"] == "http" {
    url.redirect = ("" => "https://\${url.authority}\${url.path}\${qsa}")
    url.redirect-code = 308
}
EOF

sed -i -r 's#\#.*mod_redirect.*,.*#    "mod_redirect",#g' /etc/lighttpd/lighttpd.conf

checkssl="";checkssl=$(grep 'include "mod_ssl.conf' /etc/lighttpd/lighttpd.conf);[[ "$checkssl" != "" ]] && echo listo || sed -i -r 's#.*include "mime-types.conf".*#include "mime-types.conf"\ninclude "mod_ssl.conf"#g' /etc/lighttpd/lighttpd.conf

sed -i -r 's#ssl.pemfile.*=.*#ssl.pemfile   = "/etc/ssl/certs/localhost.pem"#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart
```
## Lighttpd tunning for aggressive load
More connections, More File Descriptors

This must be used with caution. Everything is a file to a UNIX operating system. Well, every time a visitor accesses a page, lighttpd uses three file descriptors: An IP socket to the client, a FastCGI process socket, and a filehandle for the document accessed. Lighttpd stops accepting new connections when 90% of the available sockets are in use, restarting again when usage has fallen to 80%. With the default setting of 1024 file descriptors, lighttpd can handle a maximum of 307 connections. If this number are exceded file descriptor must be increrased then. This are a delicate tune due must be check your default with cat /proc/sys/fs/file-max and make sure it’s over 10,000: 
```sh
checkset="";checkset=$(grep 'max-fds' /etc/lighttpd/lighttpd.conf);[[ "$checkset" != "" ]] && echo listo || sed -i -r 's#server settings.*#server settings\nserver.max-fds = 2048\n#g' /etc/lighttpd/lighttpd.conf

rc-service lighttpd restart
```

## Lighttpd accesslog modul
```sh
cat > /etc/lighttpd/mod_extforward.conf << EOF
server.modules += ( "mod_extforward" )
extforward.forwarder = (
    "192.168.0.0/16" => "trust",
    "10.0.0.0/8" => "trust",
    "172.16.0.0/12" => "trust"
)
EOF
```