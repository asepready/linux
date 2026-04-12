# Checklist keamanan produksi — LibreNMS (Debian 12)

Dokumen ini melengkapi [README.md](README.md) dengan **urutan praktis** dan **lapisan tambahan** (SNMP, API, host, DB). Sumber perilaku resmi: [Security information](https://docs.librenms.org/General/Security/).

---

## 1. Urutan mengikuti panduan instalasi (README)

Terapkan setelah instalasi dasar jalan; urutan ini mencerminkan [HTTPS dan keamanan](README.md#https-dan-keamanan) di README.

| Langkah | Apa yang dilakukan | Rujukan lokal |
|--------|---------------------|---------------|
| 1 | Batasi siapa yang boleh mengakses UI: **firewall** (hanya IP/trusted network) atau **VPN**; hindari ekspos penuh ke internet tanpa kebutuhan. | [Firewall](README.md#firewall) |
| 2 | Aktifkan **HTTPS** (misalnya NGINX + Let’s Encrypt); pastikan DNS `server_name` sudah benar sebelum Certbot. | [Aktifkan HTTPS](README.md#aktifkan-https-nginx--lets-encrypt), contoh [examples/nginx/librenms.vhost-https.example](examples/nginx/librenms.vhost-https.example) |
| 3 | Setelah HTTPS aktif, sunting `/opt/librenms/.env`: **`SESSION_SECURE_COOKIE=true`** (pemilik berkas `librenms:librenms`). | [Cookie sesi aman](README.md#cookie-sesi-aman) |
| 4 | Jika LibreNMS di belakang **reverse proxy** / load balancer, setel **`APP_TRUSTED_PROXIES`** di `.env` (string kosong atau daftar host proxy resmi). | [Reverse proxy terpercaya](README.md#reverse-proxy-terpercaya), [Trusted Proxies](https://docs.librenms.org/General/Security/#trusted-proxies) |

---

## 2. Lapisan operasi (setelah UI aman)

| Lapisan | Tindakan |
|---------|----------|
| **Aplikasi** | Pembaruan rutin: ikuti [Updating](https://docs.librenms.org/General/Updating/) (`git pull` di `/opt/librenms` sesuai alur resmi). Setelah upgrade, jalankan `./validate.php` sebagai user `librenms`. |
| **Paket OS** | `apt update && apt upgrade` terjadwal atau berkala; reboot bila kernel meminta. |
| **SNMP ke perangkat** | Hindari community **public** / default. Utamakan **SNMPv3** (authPriv) dengan kredensial unik per zona; di perangkat jaringan, **ACL** agar hanya IP **poller** LibreNMS yang boleh SNMP. Contoh: [SNMP Configuration Examples](https://docs.librenms.org/Support/SNMP-Configuration-Examples/). |
| **API & akun UI** | Kata sandi kuat untuk pengguna web; token **API** hanya untuk layanan yang perlu, dicabut jika bocor. Aktifkan 2FA jika metode autentikasi Anda mendukung ([Authentication Options](https://docs.librenms.org/Extensions/Authentication/)). |
| **Host** | SSH dengan **kunci**, bukan kata sandi lemah; nonaktifkan layanan yang tidak dipakai. |
| **MariaDB** | Jika DB hanya lokal, pastikan `mysqld` mendengarkan **127.0.0.1** (sesuai contoh tuning di README). User DB LibreNMS hanya privilege yang diperlukan oleh instalasi resmi. |
| **Integrasi** | Oxidized, syslog, trap handler: perlakukan kredensial seperti rahasia produksi; rotasi jika dicurigai kompromi. Syslog: batasi siapa yang boleh kirim ke port **514** ([Syslog](https://docs.librenms.org/Extensions/Syslog/), [README syslog-ng terkait](../syslog-ng/README.md)). |
| **Backup & integritas** | Backup **database** dan konfigurasi penting (`config.php`, `.env` tersimpan aman); uji **restore**. Pantau **disk** (RRD, log) agar polling tidak gagal tanpa terlihat. |

---

## 3. Verifikasi cepat

- [ ] Dari jaringan tidak tepercaya, akses ke UI **ditolak** (firewall/VPN sesuai kebijakan).
- [ ] Situs dibuka lewat **`https://`**; `SESSION_SECURE_COOKIE=true` di `.env`.
- [ ] `./validate.php` tanpa error kritis setelah perubahan besar.
- [ ] Perangkat memakai SNMP yang tidak lemah (idealnya v3) dan ACL sumber ke poller.

---

## 4. Pelaporan kerentanan pada LibreNMS

Ikuti [Reporting vulnerabilities](https://docs.librenms.org/General/Security/#reporting-vulnerabilities) di dokumentasi resmi.
