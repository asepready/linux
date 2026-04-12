# LibreNMS di Debian 12 (Bookworm)

Panduan ini merangkum instalasi **LibreNMS** pada **Debian 12** dengan **NGINX** dan **PHP 8.2**, mengikuti dokumentasi resmi. Gunakan bersama berkas contoh di folder [examples/](examples/).

**Dokumentasi resmi (sumber kebenaran):** [Installing LibreNMS](https://docs.librenms.org/Installation/Install-LibreNMS/)

**Catatan URL `#__tabbed_1_4`:** pada halaman instal resmi, tab OS berurutan umumnya Ubuntu 24.04, Ubuntu 22.04, CentOS 8, **Debian 12**, Debian 13. Fragment `__tabbed_1_4` sering mengarah ke **Debian 13** (PHP 8.4, bagian `[mariadbd]`). Folder ini khusus **Debian 12** — pilih tab **Debian 12** di situs resmi, atau ikuti langkah di bawah.

**Skenario lain di repo ini:** instal Alpine ada di [distro/linux-apline/3.20/apps/LibreNMS.md](../../linux-apline/3.20/apps/LibreNMS.md) (bukan Debian).

---

## Isi dokumen

1. [Prasyarat](#prasyarat)
2. [Paket sistem](#paket-sistem)
3. [Pengguna dan kode sumber](#pengguna-dan-kode-sumber)
4. [Izin (ACL)](#izin-acl)
5. [Dependensi PHP (Composer)](#dependensi-php-composer)
6. [Zona waktu](#zona-waktu)
7. [MariaDB](#mariadb)
8. [PHP-FPM](#php-fpm)
9. [NGINX](#nginx)
10. [Firewall](#firewall)
11. [Perintah lnms](#perintah-lnms)
12. [SNMP (snmpd)](#snmp-snmpd)
13. [Cron dan penjadwal](#cron-dan-penjadwal)
14. [Logrotate](#logrotate)
15. [Instalasi lewat web](#instalasi-lewat-web)
16. [Validasi](#validasi)
17. [HTTPS dan keamanan](#https-dan-keamanan)
    - [Ringkasan resmi](#ringkasan-resmi)
    - [Aktifkan HTTPS (NGINX + Let’s Encrypt)](#aktifkan-https-nginx--lets-encrypt)
    - [Cookie sesi aman](#cookie-sesi-aman)
    - [Reverse proxy terpercaya](#reverse-proxy-terpercaya)
    - [Checklist keamanan produksi](#checklist-keamanan-produksi)
18. [Syslog ke LibreNMS (opsional)](#syslog-ke-librenms-opsional)

---

## Prasyarat

- Debian 12 terpasang, akses **root** atau **sudo** (instruksi resmi mengasumsikan root; jika tidak, tambahkan `sudo` pada perintah shell).
- Versi PHP minimum LibreNMS: **8.2** (Bookworm menyediakan PHP 8.2).
- Ikuti setiap bagian di [dokumentasi resmi](https://docs.librenms.org/Installation/Install-LibreNMS/#prepare-linux-server) bila ada perbedaan dengan rilis paket Anda.

---

## Paket sistem

Rujukan resmi: [Install Required Packages](https://docs.librenms.org/Installation/Install-LibreNMS/#install-required-packages) — pilih **Debian 12** dan **NGINX**.

Contoh satu baris (sama dengan upstream) ada di [examples/packages-debian12-nginx.txt](examples/packages-debian12-nginx.txt).

```sh
apt update
apt install acl ca-certificates curl fping git lsb-release mariadb-client mariadb-server mtr-tiny nginx-full nmap php-cli php-curl php-fpm php-gd php-gmp php-mbstring php-mysql php-snmp php-xml php-zip python3-dotenv python3-pip python3-psutil python3-pymysql python3-redis python3-setuptools python3-systemd rrdtool snmp snmpd unzip wget whois
```

---

## Pengguna dan kode sumber

Rujukan: [Add librenms user](https://docs.librenms.org/Installation/Install-LibreNMS/#add-librenms-user), [Download LibreNMS](https://docs.librenms.org/Installation/Install-LibreNMS/#download-librenms)

```sh
useradd librenms -d /opt/librenms -M -r -s "$(which bash)"
cd /opt
git clone https://github.com/librenms/librenms.git
```

---

## Izin (ACL)

Rujukan: [Set permissions](https://docs.librenms.org/Installation/Install-LibreNMS/#set-permissions)

```sh
chown -R librenms:librenms /opt/librenms
chmod 771 /opt/librenms
setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/
```

---

## Dependensi PHP (Composer)

Rujukan: [Install PHP dependencies](https://docs.librenms.org/Installation/Install-LibreNMS/#install-php-dependencies)

```sh
su - librenms
./scripts/composer_wrapper.php install --no-dev
exit
```

Bila skrip gagal lewat proxy, resmi menyarankan memasang `composer` global; lihat catatan di tautan di atas.

---

## Zona waktu

Rujukan: [Set timezone](https://docs.librenms.org/Installation/Install-LibreNMS/#set-timezone)

Pada Debian 12, sunting **FPM** dan **CLI** (ganti `Etc/UTC` sesuai kebutuhan, daftar: [php.net/timezones](https://www.php.net/manual/en/timezones.php)):

- `/etc/php/8.2/fpm/php.ini` — `date.timezone`
- `/etc/php/8.2/cli/php.ini` — `date.timezone`

```sh
timedatectl set-timezone Etc/UTC
```

---

## MariaDB

Rujukan: [Configure MariaDB](https://docs.librenms.org/Installation/Install-LibreNMS/#configure-mariadb)

1. Tambahkan opsi di bagian `[mysqld]` (contoh berkas terpisah: [examples/mariadb/99-librenms.cnf.example](examples/mariadb/99-librenms.cnf.example)):

   - `innodb_file_per_table=1`
   - `lower_case_table_names=0`

2. Aktifkan dan mulai ulang:

```sh
systemctl enable mariadb
systemctl restart mariadb
```

3. Buat basis data dan pengguna — lihat [examples/sql/librenms-init.sql.example](examples/sql/librenms-init.sql.example) (ganti kata sandi), atau jalankan perintah `CREATE`/`GRANT` seperti di dokumentasi resmi dari prompt `mysql -u root`.

---

## PHP-FPM

Rujukan: [Configure PHP-FPM](https://docs.librenms.org/Installation/Install-LibreNMS/#configure-php-fpm)

1. Salin pool bawaan lalu sesuaikan (contoh ringkas: [examples/php-fpm/librenms.pool.example](examples/php-fpm/librenms.pool.example)):

```sh
cp /etc/php/8.2/fpm/pool.d/www.conf /etc/php/8.2/fpm/pool.d/librenms.conf
```

2. Di `librenms.conf` ubah menurut resmi:

   - `[www]` → `[librenms]`
   - `user` / `group` → `librenms`
   - `listen` → `unix:/run/php-fpm-librenms.sock` (nilai tepat: `listen = /run/php-fpm-librenms.sock`)

3. Bila tidak ada aplikasi PHP lain, Anda boleh menghapus `www.conf` untuk menghemat sumber daya (opsional).

```sh
systemctl restart php8.2-fpm
```

---

## NGINX

Rujukan: [Configure Web Server](https://docs.librenms.org/Installation/Install-LibreNMS/#configure-web-server) — tab **Debian 12** + **NGINX**.

Contoh vhost: [examples/nginx/librenms.vhost.example](examples/nginx/librenms.vhost.example).

Ringkasnya:

```sh
install -D -m 0644 examples/nginx/librenms.vhost.example /etc/nginx/sites-available/librenms
ln -sf /etc/nginx/sites-available/librenms /etc/nginx/sites-enabled/librenms
# Atau nama berkas seperti upstream: sites-enabled/librenms.vhost
rm /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx
systemctl restart php8.2-fpm
```

Sesuaikan `server_name` dengan FQDN atau IP server Anda.

**SELinux:** tidak aktif secara bawaan pada Debian; lihat tab lain di resmi jika Anda memakai distro dengan SELinux.

---

## Firewall

Debian tidak selalu mengaktifkan firewall bawaan. Jika memakai **ufw**, buka HTTP (dan HTTPS bila sudah dikonfigurasi):

```sh
ufw allow 'WWW Full'
# atau: ufw allow 80/tcp
```

Rujukan ringkas: [Allow access through firewall](https://docs.librenms.org/Installation/Install-LibreNMS/#allow-access-through-firewall)

---

## Perintah lnms

Rujukan: [Enable lnms command completion](https://docs.librenms.org/Installation/Install-LibreNMS/#enable-lnms-command-completion)

```sh
ln -s /opt/librenms/lnms /usr/bin/lnms
cp /opt/librenms/misc/lnms-completion.bash /etc/bash_completion.d/
```

Konfigurasi disarankan lewat `lnms config`; lihat [Configuration](https://docs.librenms.org/Support/Configuration/) di dokumentasi LibreNMS.

---

## SNMP (snmpd)

Rujukan: [Configure snmpd (v2c)](https://docs.librenms.org/Installation/Install-LibreNMS/#configure-snmpd-v2c)

```sh
cp /opt/librenms/snmpd.conf.example /etc/snmp/snmpd.conf
# Sunting /etc/snmp/snmpd.conf — ganti RANDOMSTRINGGOESHERE dengan community string Anda
curl -o /usr/bin/distro https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro
chmod +x /usr/bin/distro
systemctl enable snmpd
systemctl restart snmpd
```

Untuk SNMPv3, lihat [contoh SNMP](https://docs.librenms.org/Support/SNMP-Configuration-Examples/#linux-snmpd-v3).

---

## Cron dan penjadwal

**Cron** — [Cron job](https://docs.librenms.org/Installation/Install-LibreNMS/#cron-job)

```sh
cp /opt/librenms/dist/librenms.cron /etc/cron.d/librenms
```

Catatan proxy pada lingkungan cron: lihat [Proxy support](https://docs.librenms.org/Support/Configuration/#proxy-support).

**systemd timer** — [Enable the scheduler](https://docs.librenms.org/Installation/Install-LibreNMS/#enable-the-scheduler)

```sh
cp /opt/librenms/dist/librenms-scheduler.service /opt/librenms/dist/librenms-scheduler.timer /etc/systemd/system/
systemctl enable librenms-scheduler.timer
systemctl start librenms-scheduler.timer
```

Untuk penjadwalan tingkat lanjut atau **Dispatcher service**, lihat [Advanced Setup](https://docs.librenms.org/Extensions/Dispatcher-Service/) di dokumentasi resmi.

---

## Logrotate

Rujukan: [Enable logrotate](https://docs.librenms.org/Installation/Install-LibreNMS/#enable-logrotate)

```sh
cp /opt/librenms/misc/librenms.logrotate /etc/logrotate.d/librenms
```

---

## Instalasi lewat web

Rujukan: [Web installer](https://docs.librenms.org/Installation/Install-LibreNMS/#web-installer), [Final steps](https://docs.librenms.org/Installation/Install-LibreNMS/#final-steps)

Buka `http://server_name_atau_ip/` di peramban dan ikuti wizard. Jika diminta membuat `config.php` manual:

```sh
chown librenms:librenms /opt/librenms/config.php
```

Tambahkan perangkat pertama (misalnya localhost): [Add the first device](https://docs.librenms.org/Installation/Install-LibreNMS/#add-the-first-device)

---

## Validasi

Rujukan: [Troubleshooting](https://docs.librenms.org/Installation/Install-LibreNMS/#troubleshooting)

```sh
su - librenms
./validate.php
exit
```

---

## HTTPS dan keamanan

Dokumentasi resmi LibreNMS: **[Security information](https://docs.librenms.org/General/Security/)** (HTTPS, cookie sesi, proxy terpercaya). Peringatan instalasi: [Final steps](https://docs.librenms.org/Installation/Install-LibreNMS/#final-steps) — skema awal panduan ini **HTTP port 80**; untuk produksi batasi akses (firewall/VPN) dan gunakan **HTTPS**.

**Checklist berlapis** (urutan firewall/HTTPS/`.env`, lalu SNMP, API, DB, backup): lihat [SECURITY-HARDENING.md](SECURITY-HARDENING.md).

### Ringkasan resmi

Menurut [General/Security](https://docs.librenms.org/General/Security/):

- **Batasi akses** ke LibreNMS lewat firewall atau VPN.
- **Pertahankan pembaruan** instalasi (kode dan paket sistem).
- **HTTPS** sangat disarankan untuk antarmuka web (misalnya sertifikat [Let’s Encrypt](https://letsencrypt.org/)).
- Setelah HTTPS aktif, aktifkan **cookie sesi aman** lewat `.env`.
- Di belakang **reverse proxy**, atur daftar proxy terpercaya agar header tidak disalahgunakan.

### Aktifkan HTTPS (NGINX + Let’s Encrypt)

1. Pastikan nama host DNS (`server_name`) sudah mengarah ke server ini.
2. Pasang Certbot dan plugin NGINX:

```sh
apt install certbot python3-certbot-nginx
```

3. Salin contoh vhost HTTPS dari repositori ini sebagai acuan, atau biarkan Certbot mengubah konfigurasi NGINX:

   - Contoh berkas: [examples/nginx/librenms.vhost-https.example](examples/nginx/librenms.vhost-https.example) (redirect HTTP→HTTPS, `listen 443 ssl`, `fastcgi_pass` ke socket yang sama seperti instal HTTP).

4. Jalankan Certbot (ganti FQDN):

```sh
certbot --nginx -d librenms.example.com
```

5. Uji konfigurasi dan muat ulang:

```sh
nginx -t && systemctl reload nginx
```

Detail opsi TLS mengikuti rekomendasi Let’s Encrypt (berkas `options-ssl-nginx.conf` dan `ssl-dhparams.pem` biasanya dibuat oleh Certbot).

### Cookie sesi aman

Setelah HTTPS berjalan, di server sunting `/opt/librenms/.env` (pemilik `librenms:librenms`) dan setel:

```env
SESSION_SECURE_COOKIE=true
```

Ini memaksa cookie sesi hanya lewat saluran aman dan mengurangi risiko penyadapan cookie (lihat [Secure Session Cookies](https://docs.librenms.org/General/Security/#secure-session-cookies)).

### Reverse proxy terpercaya

Jika LibreNMS berada di belakang proxy pembalik (misalnya load balancer), atur `APP_TRUSTED_PROXIES` di `.env` ke string kosong atau ke daftar host proxy yang diizinkan meneruskan header — lihat [Trusted Proxies](https://docs.librenms.org/General/Security/#trusted-proxies).

### Checklist keamanan produksi

Ringkasan urutan dan lapisan tambahan (SNMPv3, API, MariaDB, backup): **[SECURITY-HARDENING.md](SECURITY-HARDENING.md)**.

### Pelaporan kerentanan

Jika Anda menemukan kerentanan keamanan pada LibreNMS, ikuti arahan resmi di bagian *Reporting vulnerabilities* pada [Security information](https://docs.librenms.org/General/Security/#reporting-vulnerabilities).

---

## Syslog ke LibreNMS (opsional)

Setelah LibreNMS berada di `/opt/librenms` dan `syslog.php` tersedia, Anda dapat mengarahkan syslog ke LibreNMS dari **log server** Debian yang sama atau host lain:

- Contoh **syslog-ng**: [../syslog-ng/conf.d/11-librenms.example](../syslog-ng/conf.d/11-librenms.example)
- Panduan log server (port 514, uji, logrotate): [../syslog-ng/README.md](../syslog-ng/README.md)

Pastikan dokumentasi LibreNMS untuk syslog diperiksa: [Syslog](https://docs.librenms.org/Extensions/Syslog/).

---

## Referensi cepat

| Topik | URL resmi |
| ----- | --------- |
| Instalasi penuh | [Install-LibreNMS](https://docs.librenms.org/Installation/Install-LibreNMS/) |
| Checklist keamanan (lokal) | [SECURITY-HARDENING.md](SECURITY-HARDENING.md) |
| Keamanan (HTTPS, cookie, proxy) | [Security information](https://docs.librenms.org/General/Security/) |
| Konfigurasi | [Support/Configuration](https://docs.librenms.org/Support/Configuration/) |
| Pembaruan | [Updating](https://docs.librenms.org/General/Updating/) |
