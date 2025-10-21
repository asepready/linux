```sh
apk add --no-cache apache2

rc-update add apache2 default
rc-service apache2 restart