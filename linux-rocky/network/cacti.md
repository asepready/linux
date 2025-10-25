# Setup LEMP

```sh
dnf -y install epel-release

# RHEL & RL 8
dnf -y install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

dnf module reset php
dnf module enable php:8.2

dnf -y install bash-completion nginx mariadb-server php-fpm php-mysqlnd php-cgi

systemctl enable nginx; systemctl start nginx

#PHP
sed -i -r 's|.*cgi.fix_pathinfo=.*|cgi.fix_pathinfo=1|g' /etc/php.ini
sed -i -r 's#.*safe_mode =.*#safe_mode = Off#g' /etc/php.ini
sed -i -r 's#.*expose_php =.*#expose_php = Off#g' /etc/php.ini
sed -i -r 's#memory_limit =.*#memory_limit = 512M#g' /etc/php.ini
sed -i -r 's#upload_max_filesize =.*#upload_max_filesize = 56M#g' /etc/php.ini
sed -i -r 's#post_max_size =.*#post_max_size = 128M#g' /etc/php.ini
sed -i -r 's#^file_uploads =.*#file_uploads = On#g' /etc/php.ini
sed -i -r 's#^max_file_uploads =.*#max_file_uploads = 12#g' /etc/php.ini
sed -i -r 's#^allow_url_fopen = .*#allow_url_fopen = On#g' /etc/php.ini
sed -i -r 's#^.default_charset =.*#default_charset = "UTF-8"#g' /etc/php.ini
sed -i -r 's#^.max_execution_time =.*#max_execution_time = 90#g' /etc/php.ini
sed -i -r 's#^max_input_time =.*#max_input_time = 90#g' /etc/php.ini
sed -i -r 's#.*date.timezone =.*#date.timezone = Asia/Jakarta#g' /etc/php.ini

systemctl enable php-fpm; systemctl start php-fpm

# database
#systemctl stop mysql
#rm -rf /var/lib/mysql/*
#sudo -u mysql mysql_install_db

#/etc/my.cnf.d/server.cnf
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
innodb_file_format = Barracuda
max_allowed_packet = 16777777
join_buffer_size = 32M
innodb_file_per_table = ON
innodb_large_prefix = 1
innodb_buffer_pool_size = 250M
innodb_additional_mem_pool_size = 90M
innodb_flush_log_at_trx_commit = 2

systemctl enable mariadb; systemctl start mariadb

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
# harden mysql
mysql -u root -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -e "DROP DATABASE IF EXISTS test"
mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -u root -e "FLUSH PRIVILEGES"

# firewall
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
#

```

## Setup Cacti

```sh
dnf install cacti cacti-spine

#/etc/nginx/conf.d/cacti.conf
# Advanced config for NGINX
#server_tokens off;
add_header X-XSS-Protection "1; mode=block";
add_header X-Content-Type-Options nosniff;

# Redirect all HTTP traffic to HTTPS
server {
  listen 80;
  server_name cacti.yourdomain.com; #No one likes unencrypted web servers
  #return 301 https://$host$request_uri; # some nginx do not support 'return';
}

# SSL configuration
server {
  listen 443 ssl default deferred;
  server_name cacti.yourdomain.com;
  root /usr/share/nginx/html/cacti;
  index index.php index.html index.htm;

  # Compression increases performance0
  gzip on;
  gzip_types      text/plain text/html text/xml text/css application/xml application/javascript application/x-javascript application/rss+xml application/xhtml+xml;
  gzip_proxied    no-cache no-store private expired auth;
  gzip_min_length 1000;

  location / {
    try_files $uri $uri/ /index.php$query_string;
  }

  error_page 404 /404.html;
  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html/;
  }

  location ~ \.php$ {
    alias /usr/share/nginx/html/cacti;
    index index.php
    try_files $uri $uri/ =404;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;

    # you may have to change the path here for your OS
    fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include /etc/nginx/fastcgi_params;
  }

  location /cacti {
    root /usr/share/nginx/html/;
    index index.php index.html index.htm;
    location ~ ^/cacti/(.+\.php)$ {
      try_files $uri =404;
      root /usr/share/nginx/html;

      # you may have to change the path here for your OS
      fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include /etc/nginx/fastcgi_params;
    }

    location ~* ^/cacti/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
      expires max;
      log_not_found off;
    }
  }

  location /doc/ {
    alias /usr/share/nginx/html/cacti/doc/;
    location ~* ^/docs/(.+\.(html|md|txt))$ {
      root /usr/share/nginx/html/cacti/;
      autoindex on;
      allow 127.0.0.1; # Change this to allow your local networks
      allow ::1;
      deny all;
    }
  }

  location /cacti/rra/ {
    deny all;
  }

  ## Access and error logs.
  access_log /var/log/nginx/cacti_access.log;
  error_log  /var/log/nginx/cacti_error.log info;

  ssl_certificate      /etc/ssl/certs/YourOwnCertFile.crt;
  ssl_certificate_key  /etc/ssl/private/YourOwnCertKey.key;

  # Improve HTTPS performance with session resumption
  ssl_session_cache shared:SSL:10m;
  ssl_session_timeout 5m;

  # Enable server-side protection against BEAST attacks
  #ssl_prefer_server_ciphers on;
  ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;

  # Disable SSLv3
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

  # Diffie-Hellman parameter for DHE cipher suites
  # $ sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
  ssl_dhparam /etc/ssl/certs/dhparam.pem;

  # Enable HSTS (https://developer.mozilla.org/en-US/docs/Security/HTTP_Strict_Transport_Security)
  add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
}
```
