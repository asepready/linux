# Compile Tool
apt-get install -y build-essential dos2unix dh-autoreconf libtool help2man libssl-dev libmysql++-dev librrds-perl libsnmp-dev

# cacti 
https://github.com/Cacti/cacti/releases/tag/release%2F1.2.27

# spine 
wget https://github.com/Cacti/spine/archive/refs/tags/release/1.2.27.tar.gz
./bootstrap
./configure
make
make install
chown root:root /usr/local/spine/bin/spine
chmod u+s /usr/local/spine/bin/spine