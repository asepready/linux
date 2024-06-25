## Setting up the repository
```sh
#
mkdir -p /apk/v3.8/main/x86 && cd /apk/v3.8/main/x86
apk fetch --recursive namapacket

apk index -vU -o APKINDEX.tar.gz *.apk


apk add gcc abuild --no-cache
abuild-keygen -a -i

abuild-sign -k /apk/apk.asepready.id.rsa /apk/v3.8/main/x86/APKINDEX.tar.gz

# Nginx Config
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    ssl on;
    ssl_certificate /etc/nginx/ssl/apk.crt;
    ssl_certificate_key /etc/nginx/ssl/apk.key;

    server_name apk.example.com;
    root /apk;

    location / {
        autoindex on;
    }
}

# Add our repository to `/etc/apk/repositories
echo "http://apk.asepready.id/v3.8/main" | tee -a /etc/apk/repositories
wget -P /etc/apk/keys/ http://apk.asepready.id/apk.asepready.id.rsa.pub
apk update --allow-untrusted

```