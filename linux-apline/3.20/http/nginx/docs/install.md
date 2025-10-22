https://blog.nginx.org/
https://blog.nginx.org/blog/compiling-and-installing-modsecurity-for-open-source-nginx

```sh
apk add nginx php-fpm


apk add openssl

mkdir -p /etc/ssl/certs/
openssl req -x509 -days 1460 -nodes -newkey rsa:2048 \
   -subj "/C=ID/ST=Babel/L=PKP/O=Edu:Local/OU=Edu:/CN=localhost" \
   -keyout /etc/ssl/certs/localhost.pem -out /etc/ssl/certs/localhost.pem

chmod 400 /etc/ssl/certs/localhost.pem
```
