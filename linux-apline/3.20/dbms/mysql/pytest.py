# alpine linux
# apk add --no-cache py3-mysqlclient 

# debian
# apt install python3-mysql.connector

#!/usr/bin/python
# Note (Example is valid for Python v2 and v3)
from __future__ import print_function
import sys
 
import mysql.connector
from mysql.connector.constants import ClientFlag
 
config = {
    'user': 'root',
    'password': 'wT5?iY2)vO6#aW7&',
    'host': '192.168.20.4',
    'client_flags': [ClientFlag.SSL],
    'ssl_ca': '/etc/mysql/ssl/ca-cert.pem',
    'ssl_cert': '/etc/mysql/ssl/client-cert.pem',
    'ssl_key': '/etc/mysql/ssl/client-key.pem',
}

cnx = mysql.connector.connect(**config)
cur = cnx.cursor(buffered=True)
cur.execute("SHOW STATUS LIKE 'Ssl_cipher'")
print(cur.fetchone())
cur.close()
cnx.close()