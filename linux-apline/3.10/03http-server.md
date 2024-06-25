# Layanan HTTP
## Install Paket Nginx, SSL(OpenSSL) dan PHP7
```sh
apk add --no-cache nginx openssl 
apk add --no-cache php7-fpm php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype

mkdir -p /etc/nginx/ssl && cd /etc/nginx/ssl
mv /etc/nginx/http.d/default.conf /etc/nginx/http.d/default.conf.orig
```
## Konfigurasi Paket Nginx dan SSL(OpenSSL)
Lakukan buat konfigurasi file seperti berikut ini:
```t
/etc/
├── nginx/
│   ├── http.d/
│   │   ├── default.conf
│   │   ├── repo.conf
│   │   └── sites.conf
│   ├── fastcgi.conf
│   ├── fastcgi_params
│   ├── mime.types
│   ├── modules/
│   ├── nginx.conf
│   ├── scgi_params
│   └── uwsgi_params
```
Konfigurasi PHP-FPM pada dir /etc/nginx/*.conf
```conf 
	location ~ \.php$ {
		fastcgi_pass	127.0.0.1:9000;
		fastcgi_index	index.php;
		fastcgi_param	SCRIPT_FILENAME  $document_root$fastcgi_script_name;
		include		fastcgi_params;
	}
```
- [lihat file default.conf](./http/http-nginx/http.d/default.conf)(./http/http-nginx/http.d/default.conf)
- [lihat file repo.conf](./http/http-nginx/http.d/repo.conf)(./http/http-nginx/http.d/repo.conf)
- [lihat file sites.conf](./http/http-nginx/http.d/sites.conf)(./http/http-nginx/http.d/sites.conf)

Jalan Server
Pertama, cek hasil kunfigurasi:
```sh
nginx -t
```
Akhiri, memulai dan aktifkan saat memulai boot:
```sh
rc-service nginx start && rc-service php-fpm7 start
rc-update add nginx && rc-update add php-fpm7
```