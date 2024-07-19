# Layanan HTTP
## Install Paket Nginx, SSL(OpenSSL) dan PHP7
```sh
apk add --no-cache nginx openssl php7-fpm
mkdir -p /etc/nginx/ssl && cd /etc/nginx/ssl
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.orig
```
## Konfigurasi Paket Nginx dan SSL(OpenSSL)
Lakukan buat konfigurasi file seperti berikut ini:
```t
/etc/
├── nginx/
│   ├── conf.d/
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
- [lihat file default.conf](./http/http-nginx/conf.d/default.conf)(./http/http-nginx/conf.d/default.conf)
- [lihat file repo.conf](./http/http-nginx/conf.d/repo.conf)(./http/http-nginx/conf.d/repo.conf)
- [lihat file sites.conf](./http/http-nginx/conf.d/sites.conf)(./http/http-nginx/conf.d/sites.conf)

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