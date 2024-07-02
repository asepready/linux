## 1. Konfigurasi Repositori Alpine Linux
https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper

Buka dan edit untuk repo di /etc/apk/repositories
```sh file
#/media/cdrom/apks
#http://mirror.jingk.ai/alpine/v3.8/main
#http://mirror.jingk.ai/alpine/v3.8/community

http://apk.asepready.id/v3.8/main

```
Lakukan pengecekan pembaruan reposetori'
```sh
apk update --no-cache
```
## 2 Pengujian Repository
```sh
apk add --no-cache tzdata
ln -s /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sed -i "s|;*date.timezone =.*|date.timezone = Asia/Jakarta|i" /etc/php*/php.ini
```