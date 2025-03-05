docker run --name nagios  \
  -e "ID=Asia/Jakarta" \
  -e NAGIOSADMIN_USER="admin" \
  -e NAGIOSADMIN_PASS="admin" \
  -p 0.0.0.0:10000:80 \
  manios/nagios:latest