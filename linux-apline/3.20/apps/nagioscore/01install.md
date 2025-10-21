https://wiki.alpinelinux.org/wiki/Setting_up_A_Network_Monitoring_and_Inventory_System
Install lighttpd
Basic Installation

For installing the additional packages first activate community packages and update the package index

Install the required packages:

# apk add lighttpd lighttpd-mod_auth php82 fcgi php82-cgi
Configure Lighttpd

Edit lighttpd.conf (/etc/lighttpd/lighttpd.conf) and uncomment the line:

Contents of /etc/lighttpd/lighttpd.conf
...
include "mod_fastcgi.conf"
...

Edit mod_fastcgi.conf (/etc/lighttpd/mod_fastcgi.conf), find and change /usr/bin/php-cgi to /usr/bin/php-cgi82.

Contents of /etc/lighttpd/mod_fastcgi.conf
...
"bin-path" => "/usr/bin/php-cgi82" # php-cgi
...
Start lighttpd service and add it to default runlevel

# rc-service lighttpd start 
# rc-update add lighttpd default
Configure MySQL

/usr/bin/mysql_install_db --user=mysql
rc-service mysql start && rc-update add mysql default
/usr/bin/mysqladmin -u root password 'password'

Install Nagios, nagios-plugins and Nagiosql and other needed packages

apk add nagios nagios-web nagios-plugins nagiosql php-mysqli php-mysql

Create soft-link for nagiosql virtual host'

ln -s /usr/share/webapps/nagiosql /var/www/localhost/htdocs/nagiosql

Change permissions for nagiosql

chown lighttpd:lighttpd /usr/share/webapps/nagiosql/config

Browse to http://localhost/nagiosql and follow the setup instructions. Create folder /usr/share/webapps/openaudit and link to virtual host folder

mkdir /usr/share/webapps/openaudit
chown lighttpd:lighttpd /usr/share/webapps/openaudit
ln -s /usr/share/webapps/openaudit /var/www/localhost/htdocs/openaudit</nowiki>

Download openaudit from https://downloads.sourceforge.net/open-audit/openauditrelease-09.12.23-SVN1233.zip and extract to /usr/share/webapps/openaudit.

On a Windows server, create scheduled tasks to run ping-sweep-main.bat, lookup-main.bat and insert-hosts-main.bat on a regular basis. Since the insert-hosts-main.bat file runs RPC calls against other Windows servers, at the moment this section needs to run on a Windows server...

To be continued...