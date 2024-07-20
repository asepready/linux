#!/bin/sh

DIR=loganalyzer
DLDIR=loganalyzer
FILE=loganalyzer-4.1.13.tar.gz

mkdir -p /var/www/html/$DIR
# Check whether we have sufficient privileges
if [ $(id -u) -ne 0 ]; then
    echo "This script needs to be run as root/superuser." >&2
    exit 1
fi
    
if ! which wget &>/dev/null; then
    apk add wget
fi

cd /tmp
echo "check if /tmp/nagioslogserver exists"
if [ ! -d /tmp/$DIR ]; then
    rm -f /tmp/$DIR
    wget https://download.adiscon.com/$DLDIR/$FILE -O /tmp/$FILE
    tar xzf /tmp/$FILE
fi
cd /tmp/$DIR
chmod +x ./fullinstall
./fullinstall
