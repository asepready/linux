Message Error Apache2 ?
Error message "Forbidden You don't have permission to access / on this server"

Original Answer

I faced the same issue, but I solved it by setting the options directive either in the global directory setting in the httpd.conf or in the specific directory block in httpd-vhosts.conf:

Options Indexes FollowSymLinks Includes ExecCGI

By default, your global directory settings is (httpd.conf line ~188):
```sh
<Directory />
    Options FollowSymLinks
    AllowOverride All
    Order deny,allow
    Allow from all
</Directory>
```
set the options to: Options Indexes FollowSymLinks Includes ExecCGI

Finally, it should look like:
```sh
<Directory />
    #Options FollowSymLinks
    Options Indexes FollowSymLinks Includes ExecCGI
    AllowOverride All
    Order deny,allow
    Allow from all
</Directory>
```
Also try changing Order deny,allow and Allow from all lines by Require all granted.

apk add apache2 php82-apache2 php82 fcgi php82-cgi