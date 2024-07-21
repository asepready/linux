# /etc/lighttpd/rrdtool.sh
```sh
cat > /etc/lighttpd/rrdtool.sh << EOF
#!/bin/sh

RRDTOOL=/usr/bin/rrdtool
OUTDIR=/var/www/html/
INFILE=/var/lib/lighttpd/lighttpd.rrd
OUTPRE=lighttpd-traffic
WIDTH=400
HEIGHT=100

DISP="-v bytes --title TrafficWebserver \
        DEF:binraw=$INFILE:InOctets:AVERAGE \
        DEF:binmaxraw=$INFILE:InOctets:MAX \
        DEF:binminraw=$INFILE:InOctets:MIN \
        DEF:bout=$INFILE:OutOctets:AVERAGE \
        DEF:boutmax=$INFILE:OutOctets:MAX \
        DEF:boutmin=$INFILE:OutOctets:MIN \
        CDEF:bin=binraw,-1,* \
        CDEF:binmax=binmaxraw,-1,* \
        CDEF:binmin=binminraw,-1,* \
        CDEF:binminmax=binmaxraw,binminraw,- \
        CDEF:boutminmax=boutmax,boutmin,- \
        AREA:binmin#ffffff: \
        STACK:binmax#f00000: \
        LINE1:binmin#a0a0a0: \
        LINE1:binmax#a0a0a0: \
        LINE2:bin#efb71d:incoming \
        GPRINT:bin:MIN:%.2lf \
        GPRINT:bin:AVERAGE:%.2lf \
        GPRINT:bin:MAX:%.2lf \
        AREA:boutmin#ffffff: \
        STACK:boutminmax#00f000: \
        LINE1:boutmin#a0a0a0: \
        LINE1:boutmax#a0a0a0: \
        LINE2:bout#a0a735:outgoing \
        GPRINT:bout:MIN:%.2lf \
        GPRINT:bout:AVERAGE:%.2lf \
        GPRINT:bout:MAX:%.2lf \
        " 

$RRDTOOL graph $OUTDIR/$OUTPRE-hour.png -a PNG --start -14400 $DISP -w $WIDTH -h $HEIGHT
$RRDTOOL graph $OUTDIR/$OUTPRE-day.png -a PNG --start -86400 $DISP -w $WIDTH -h $HEIGHT
$RRDTOOL graph $OUTDIR/$OUTPRE-month.png -a PNG --start -2592000 $DISP -w $WIDTH -h $HEIGHT

OUTPRE=lighttpd-requests

DISP="-v req --title RequestsperSecond -u 1 \
        DEF:req=$INFILE:Requests:AVERAGE \
        DEF:reqmax=$INFILE:Requests:MAX \
        DEF:reqmin=$INFILE:Requests:MIN \
        CDEF:reqminmax=reqmax,reqmin,- \
        AREA:reqmin#ffffff: \
        STACK:reqminmax#00f000: \
        LINE1:reqmin#a0a0a0: \
        LINE1:reqmax#a0a0a0: \
        LINE2:req#00a735:requests" 

$RRDTOOL graph $OUTDIR/$OUTPRE-hour.png -a PNG --start -14400 $DISP -w $WIDTH -h $HEIGHT
$RRDTOOL graph $OUTDIR/$OUTPRE-day.png -a PNG --start -86400 $DISP -w $WIDTH -h $HEIGHT
$RRDTOOL graph $OUTDIR/$OUTPRE-month.png -a PNG --start -2592000 $DISP -w $WIDTH -h $HEIGHT
EOF

chmod +x /etc/lighttpd/rrdtool.sh
# Crond
crontab -u lighttpd -e
0,20,40 * * * * nice -n 10 /etc/lighttpd/rrdtool.sh >& /dev/null
```

```html
cat > /var/www/html/rrdtool.html << EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
        <title>Lighttpd traffic &amp; requests</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <meta http-equiv="content-style-type" content="text/css">
        <style type="text/css">
<!--
        div { text-align:center; }
        img { width:693px; height:431px; }
-->
        </style>
</head>

<body>
    <div>
        <h2>Lighttpd Traffic</h2>
        <img src="lighttpd-traffic-hour.png"   alt="graph1"><br>
        <img src="lighttpd-traffic-day.png"    alt="graph2"><br>
        <img src="lighttpd-traffic-month.png"  alt="graph3"><br>
    </div>
    <div>
        <h2>Lighttpd Requests</h2>
        <img src="lighttpd-requests-hour.png"  alt="graph4"><br>
        <img src="lighttpd-requests-day.png"   alt="graph5"><br>
        <img src="lighttpd-requests-month.png" alt="graph6"><br>
    </div>
  </body>
</html>
EOF
```
