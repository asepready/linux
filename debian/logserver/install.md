apt install apt-transport-https gpg
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list
apt update && apt install elasticsearch

apt install rsyslog rsyslog-elasticsearch elasticsearch

systemctl daemon-reload;systemctl enable elasticsearch.service
systemctl start elasticsearch.service
