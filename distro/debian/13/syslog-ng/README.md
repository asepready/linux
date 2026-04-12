# Log server Debian 12 — syslog-ng dan logrotate

Dokumentasi untuk menjalankan **central log server** di **Debian 12 (Bookworm)**: **syslog-ng** menerima log dari jaringan (UDP/TCP 514), menulis ke file di bawah `/var/log/`, dan **logrotate** mengatur rotasi serta retensi.

## Isi dokumen

1. [Alur singkat](#alur-singkat)
2. [Prasyarat](#prasyarat)
3. [Paket Debian](#paket-debian)
4. [Struktur contoh konfigurasi](#struktur-contoh-konfigurasi)
5. [Langkah pemasangan](#langkah-pemasangan)
6. [Konfigurasi klien](#konfigurasi-klien)
7. [Memantau IP, port, dan domain](#memantau-ip-port-dan-domain)
8. [Direktori log dan create-dirs](#direktori-log-dan-create-dirs)
9. [Bila beberapa pernyataan log aktif sekaligus](#bila-beberapa-pernyataan-log-aktif-sekaligus)
10. [systemd](#systemd)
11. [Firewall](#firewall)
12. [logrotate](#logrotate)
13. [Keamanan](#keamanan)
14. [Verifikasi](#verifikasi)
15. [Pemecahan masalah](#pemecahan-masalah)
16. [Referensi](#referensi)

---

## Alur singkat

```mermaid
flowchart LR
  clients[Clients_UDP_TCP_514]
  syslogNg[syslog_ng]
  files[Var_log_files]
  logrotate[logrotate]
  clients --> syslogNg --> files --> logrotate
```

---

## Prasyarat

- Debian 12 (Bookworm) dengan akses **root** atau **sudo**.
- Antara server log dan pengirim log: **rute IP** jelas; untuk produksi sebaiknya **jam sinkron** (NTP) agar urutan dan nama file tanggal konsisten.
- Memahami bahwa syslog klasik di port **514** umumnya **tanpa enkripsi** (lihat [Keamanan](#keamanan)).

---

## Paket Debian

```sh
sudo apt update
sudo apt install -y syslog-ng logrotate
```

| Paket | Keterangan |
| ----- | ---------- |
| **`syslog-ng`** | Metapaket: menarik **`syslog-ng-core`** (daemon, konfigurasi inti) dan dependensi umum. Untuk pembelajaran cukup `apt install syslog-ng`; **`syslog-ng-core`** tidak perlu dipasang terpisah kecuali skenario khusus (misalnya hanya ingin paket inti). |
| **`logrotate`** | Jadwal rotasi, kompresi, penghapusan salinan lama. Sering sudah terpasang di instalasi server. |

---

## Struktur contoh konfigurasi

File utama: `/etc/syslog-ng/syslog-ng.conf` — biasanya memuat `@include "conf.d/*.conf"`.

Contoh di folder [conf.d/](conf.d/) di repositori ini memakai **prefiks angka** agar urutan muat konsisten:

| Berkas | Peran |
| ------ | ----- |
| [conf.d/10-conn.conf.example](conf.d/10-conn.conf.example) | Mendefinisikan sumber jaringan **`s_net`** (UDP dan TCP port **514**). **Wajib** jika Anda memakai contoh 11 atau 20 yang bergantung pada `s_net`. |
| [conf.d/11-librenms.example](conf.d/11-librenms.example) | Mengirim log ke skrip LibreNMS (`/opt/librenms/syslog.php`). Memakai **`s_net`** (dari 10) dan **`s_src`** (sumber lokal bawaan dari `syslog-ng.conf`). Hanya relevan jika LibreNMS sudah terpasang dan dikonfigurasi. |
| [conf.d/20-routers.conf.example](conf.d/20-routers.conf.example) | Filter untuk pola pesan RouterOS + tujuan file per host di `/var/log/mikrotik/<HOST>/$R_YEAR-$R_MONTH-$R_DAY.log`. Membutuhkan **`s_net`** dari `10-conn`. Makro **`$R_*`** = waktu **penerimaan** di syslog-ng. |
| [conf.d/21-firewall-dns-monitor.conf.example](conf.d/21-firewall-dns-monitor.conf.example) | Memecah log **firewall** dan **DNS** RouterOS ke file terpisah per host (subfolder `firewall/` dan `dns/`) agar mudah dipantau **IP/port** vs **domain**. Membutuhkan **`s_net`**. Lihat [Memantau IP, port, dan domain](#memantau-ip-port-dan-domain). |
| [examples/mikrotik-remote-logging.rsc.example](examples/mikrotik-remote-logging.rsc.example) | Contoh perintah **RouterOS** untuk action syslog jarak jauh + topik `firewall` dan `dns`. |

**Menyalin ke sistem:** salin berkas yang dipakai ke `/etc/syslog-ng/conf.d/`, hapus sufiks `.example`, sesuaikan isi, lalu uji dengan `syslog-ng -s` sebelum `reload`.

---

## Langkah pemasangan

1. Pasang paket (lihat [Paket Debian](#paket-debian)).
2. Pilih skenario:
   - **Hanya arsip file router (Mikrotik/RouterOS):** aktifkan **`10-conn`** + **`20-routers`**.
   - **Arsip router + file terpisah firewall/DNS (IP/port & domain):** aktifkan **`10-conn`** + **`21-firewall-dns-monitor`**; router mengirim topik `firewall` dan `dns` (lihat [Memantau IP, port, dan domain](#memantau-ip-port-dan-domain)).
   - **Hanya integrasi LibreNMS:** aktifkan **`10-conn`** + **`11-librenms`** (pastikan LibreNMS dan `syslog.php` ada).
   - **Keduanya:** aktifkan **10 + 11 + 20** — perilaku alur pesan dijelaskan di [Bila beberapa pernyataan log aktif sekaligus](#bila-beberapa-pernyataan-log-aktif-sekaligus).
3. Salin berkas `.example` yang dipilih ke `/etc/syslog-ng/conf.d/` dengan nama berakhiran `.conf`.
4. Uji sintaks dan muat ulang:

```sh
sudo syslog-ng -s
sudo systemctl reload syslog-ng
```

5. Konfigurasi [firewall](#firewall) jika dipakai.
6. Atur [logrotate](#logrotate) untuk path log yang dipakai (misalnya `/var/log/mikrotik/*/*.log`).
7. Uji dari [klien](#konfigurasi-klien) dan [verifikasi](#verifikasi).

---

## Konfigurasi klien

### Linux / utilitas `logger`

Dari host lain (ganti `IP_LOG_SERVER`):

```sh
logger -n IP_LOG_SERVER --tcp -P 514 "uji syslog tcp dari klien"
logger -n IP_LOG_SERVER -P 514 "uji syslog udp dari klien"
```

### RouterOS (Mikrotik) — gambaran umum

Di perangkat Mikrotik Anda perlu:

- **Action** syslog yang mengarah ke **IP server** ini (UDP atau TCP sesuai kebijakan Anda; contoh server mendengarkan keduanya).
- **Logging rule** yang mengirim topik yang diinginkan (info, error, firewall, dll.) ke action tersebut.

Detail perintah bervariasi menurut versi RouterOS; rujuk dokumentasi Mikrotik untuk *remote logging* / *syslog* pada versi Anda. Pastikan **tidak ada firewall** di antara router dan server yang memblokir **514/udp** atau **514/tcp** (mana yang Anda pakai). Contoh siap tempel: [examples/mikrotik-remote-logging.rsc.example](examples/mikrotik-remote-logging.rsc.example).

---

## Memantau IP, port, dan domain

- **IP dan port** pada umumnya muncul di pesan **topik firewall** setelah Anda mengaktifkan pencatatan pada aturan firewall yang relevan (`log=yes` atau `action=log` pada *chain* yang dipakai).
- **Domain** (nama yang dicari klien) umumnya terlihat lewat **topik DNS** bila router meneruskan/mencatat query DNS.

Di server: aktifkan **`10-conn`** + **[21-firewall-dns-monitor.conf.example](conf.d/21-firewall-dns-monitor.conf.example)** (salin tanpa `.example`) agar log masuk ke:

- `/var/log/mikrotik/<HOST>/firewall/<TAHUN>-<BULAN>-<HARI>.log`
- `/var/log/mikrotik/<HOST>/dns/<TAHUN>-<BULAN>-<HARI>.log`

Pantau lansung:

```sh
sudo tail -f /var/log/mikrotik/*/firewall/*.log
sudo tail -f /var/log/mikrotik/*/dns/*.log
```

Bila **[20-routers](conf.d/20-routers.conf.example)** juga aktif, pesan yang sama bisa tertulis **dua kali** (file harian gabungan + file `firewall`/`dns`). Nonaktifkan salah satu skema jika ingin tanpa duplikasi.

---

## Direktori log dan create-dirs

Pada [conf.d/20-routers.conf.example](conf.d/20-routers.conf.example), opsi **`create-dirs(yes)`** pada `destination` `file()` membuat **direktori induk otomatis** (termasuk `/var/log/mikrotik/` dan subfolder per **`${HOST}`**) saat syslog-ng pertama kali menulis ke path tersebut. **Anda tidak wajib** membuat direktori itu manual kecuali ingin mengatur kepemilikan/izin khusus sebelum log pertama.

Pastikan proses syslog-ng (biasanya sebagai root) diizinkan menulis di bawah `/var/log/` — untuk layout standar ini biasanya tidak bermasalah.

---

## Bila beberapa pernyataan log aktif sekaligus

Secara bawaan, satu pesan yang masuk lewat **`s_net`** dapat **cocok dengan lebih dari satu** pernyataan `log { }`:

- Jika **11-librenms** dan **20-routers** keduanya aktif, log dari jaringan yang lolos filter Mikrotik bisa ditulis ke **file** *dan* tetap diteruskan ke **LibreNMS** (sesuai filter dan aturan masing-masing).
- Untuk membatasi duplikasi atau mengubah prioritas, Anda perlu menyesuaikan filter, `flags(final)`, atau memisahkan port/sumber — topik lanjutan di luar dokumen pemula ini.

---

## systemd

```sh
sudo systemctl enable syslog-ng
sudo systemctl start syslog-ng
sudo systemctl status syslog-ng
```

**Journald:** Debian tetap memakai `systemd-journald` untuk log lokal. syslog-ng dapat berjalan bersamaan; pengiriman ke “log server” ini berasal dari **klien/perangkat lain** kecuali Anda juga mengarahkan log lokal ke syslog-ng secara eksplisit.

---

## Firewall

Agar host lain dapat mengirim syslog, buka **514/udp** dan **514/tcp** jika keduanya dipakai di [10-conn.conf.example](conf.d/10-conn.conf.example).

Contoh **UFW**:

```sh
sudo ufw allow 514/udp
sudo ufw allow 514/tcp
sudo ufw reload
```

Sesuaikan jika Anda hanya memakai satu protokol. Periksa juga aturan di router atau cloud security group.

---

## logrotate

Contoh untuk pola file di [20-routers.conf.example](conf.d/20-routers.conf.example) — simpan misalnya sebagai `/etc/logrotate.d/routers`:

```
/var/log/mikrotik/*/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root adm
    sharedscripts
    postrotate
        invoke-rc.d syslog-ng reload > /dev/null 2>&1 || true
    endscript
}

/var/log/mikrotik/*/firewall/*.log
/var/log/mikrotik/*/dns/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root adm
    sharedscripts
    postrotate
        invoke-rc.d syslog-ng reload > /dev/null 2>&1 || true
    endscript
}
```

| Opsi | Arti singkat |
| ---- | ------------- |
| `daily` / `rotate 14` | Rotasi harian, simpan 14 salinan lama (sesuaikan kebutuhan). |
| `compress` / `delaycompress` | Kompresi salinan; `delaycompress` menunda satu siklus agar file “kemarin” masih utuh satu hari. |
| `postrotate` + reload syslog-ng | Meminta daemon membuka ulang file setelah rotasi agar penulisan tidak menempel pada inode lama. |

Uji konfigurasi (debug, tidak selalu benar-benar memutar):

```sh
sudo logrotate -d /etc/logrotate.d/routers
```

`logrotate` di Debian biasanya dijalankan **harian** lewat cron (`/etc/cron.daily/logrotate`). Sesuaikan glob path jika Anda mengubah skema direktori log.

---

## Keamanan

- Lalu lintas syslog ke port **514** umumnya **tidak dienkripsi** dan **tanpa autentikasi kuat** pada skema klasik. Untuk jaringan tidak tepercaya, pertimbangkan **VPN**, **segmentasi**, atau pembatasan sumber IP di firewall.
- Hanya buka port yang benar-benar dipakai (UDP dan/atau TCP).
- LibreNMS dan skrip `program()` memproses data mentah — pastikan izin file dan pembaruan LibreNMS mengikuti praktik aman.

---

## Verifikasi

**Server — mendengarkan:**

```sh
sudo ss -ulnp | grep 514
sudo ss -tlnp | grep 514
```

**Melihat log file (skema 20-routers):**

Pertama pastikan ada berkas (kalau belum pernah ada log yang lolos filter, direktori/file belum dibuat):

```sh
sudo ls -la /var/log/mikrotik
sudo find /var/log/mikrotik -type f -name '*.log' 2>/dev/null
```

Jika `find` mengembalikan kosong, **jangan** memakai glob ke `tail` — di banyak shell, pola `*` yang tidak cocok membuat `tail` mengeluh *No such file or directory*. Setelah ada minimal satu file `.log`:

```sh
sudo tail -f /var/log/mikrotik/*/*.log
```

Atau pantau semua file di pohon itu tanpa bergantung pada glob:

```sh
sudo find /var/log/mikrotik -name '*.log' -print0 | sudo xargs -0 tail -f
```

**Klien:** gunakan `logger` seperti di [Konfigurasi klien](#konfigurasi-klien). Untuk skema Mikrotik, kirim log nyata dari router setelah action/logging dikonfigurasi. Ingat: pesan uji `logger` biasanya **tidak** mengandung pola topik RouterOS (`system,`, `wireless,`, dll.), sehingga bisa **tidak** masuk file jika hanya [20-routers](conf.d/20-routers.conf.example) dengan filter Mikrotik yang aktif — lihat [Pemecahan masalah](#pemecahan-masalah).

---

## Pemecahan masalah

| Gejala | Yang diperiksa |
| ------ | ---------------- |
| `syslog-ng -s` gagal | Typo nama `source`/`destination`, file `conf.d` tidak konsisten (misalnya `20` tanpa `10`). |
| Port 514 tidak listen | Layanan jalan? (`systemctl status syslog-ng`). Konflik dengan daemon syslog lain (jarang jika hanya syslog-ng). |
| `tail: cannot open '.../mikrotik/*/*.log': No such file or directory` | Belum ada satu pun file `.log` di bawah `/var/log/mikrotik/` (glob tidak cocok). Cek dengan `ls` / `find` di atas. Penyebab umum: belum ada log yang diterima, konfigurasi **10**+**20** belum aktif, atau **filter** menolak pesan (pesan `logger` uji sering tidak mengandung `system,` / topik RouterOS). |
| File log tidak muncul | Filter di **20-routers** tidak cocok dengan format pesan pengirim; uji dengan `logger` sederhana (mungkin tidak lolos filter Mikrotik). Untuk uji cepat file, sementara longgarkan filter atau kirim pesan yang mengandung pola yang di-`match`. |
| LibreNMS tidak menerima | Path `/opt/librenms/syslog.php`, izin eksekusi, dan dokumentasi LibreNMS untuk syslog. Pastikan **11** terpasang dan `s_src`/`s_net` sesuai instalasi Anda. |
| Setelah rotasi, log “aneh” atau kosong | Pastikan `postrotate` memuat ulang syslog-ng; cek izin `create` di logrotate vs `owner`/`group`/`perm` di `destination`. |

Log layanan:

```sh
sudo journalctl -u syslog-ng -b --no-pager
```

---

## Referensi

- [Paket syslog-ng — Debian bookworm](https://packages.debian.org/bookworm/syslog-ng)
- [Dokumentasi syslog-ng (Open Source Edition)](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition)
- [LibreNMS — Syslog](https://docs.librenms.org/Extensions/Syslog/) (jika memakai integrasi 11-librenms)
