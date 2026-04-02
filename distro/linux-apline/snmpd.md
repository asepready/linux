## SNMP
apk add --no-cache net-snmp net-snmp-tools net-snmp-libs rrdtool

cat > /etc/snmp/snmpd.conf << EOF
view systemonly included .1.3.6.1.2.1.1
view systemonly included .1.3.6.1.2.1.25.1
rocommunity  public localhost
rocommunity  public default -V systemonly
sysLocation    Bolivar Upata Venezuela
sysContact     infoadmin <info@pacificnetwork.com>
sysServices    72
EOF

rc-update add snmpd default;rc-service snmpd restart