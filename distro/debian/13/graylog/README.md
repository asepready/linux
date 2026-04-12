# Graylog di Debian 13 (Trixie)

Panduan ini merangkum pemasangan **Graylog 7** pada **Debian 13 (Trixie)**. Ada **dua jalur** backend indeks yang umum di dokumentasi resmi:

1. **Graylog Data Node** — arsitektur **Graylog Core** (satu node **Graylog + MongoDB**, satu node **Data Node**): [Debian Installation: Single Graylog Node](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation.htm).
2. **OpenSearch self-managed** — Anda memasang **OpenSearch** dari repositori OpenSearch dan mengarahkan Graylog lewat **`elasticsearch_hosts`**: [Debian Installation with Self-Managed OpenSearch](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_os.htm).

Gunakan bersama cuplikan di folder [examples/](examples/).

**Versi dengan dukungan vendor Debian yang lebih eksplisit di matriks Graylog/MongoDB:** lihat [Graylog di Debian 12 (Bookworm)](../12/graylog/README.md).

**Perbandingan di repo ini:** untuk log server berbasis **syslog klasik ke file** (tanpa stack Graylog), lihat [syslog-ng](../../12/syslog-ng/README.md) (contoh path Debian 12; sesuaikan jika Anda menambahkan panduan syslog untuk Debian 13).

---

## Isi dokumen

1. [Debian 13 (Trixie) dan dukungan vendor](#debian-13-trixie-dan-dukungan-vendor)
2. [Pengantar](#pengantar)
3. [Arsitektur minimal (resmi)](#arsitektur-minimal-resmi)
4. [Prasyarat](#prasyarat)
5. [Zona waktu](#zona-waktu)
6. [MongoDB 8.0](#mongodb-80)
7. [Data Node](#data-node)
8. [Jalur alternatif: OpenSearch self-managed](#jalur-alternatif-opensearch-self-managed)
9. [Graylog Server](#graylog-server)
10. [Gambaran pengaturan konfigurasi](#gambaran-pengaturan-konfigurasi)
11. [Preflight dan UI pertama](#preflight-dan-ui-pertama) — [login pertama (preflight)](#login-pertama-preflight), [setelah preflight selesai](#setelah-preflight-selesai)
12. [Firewall dan verifikasi](#firewall-dan-verifikasi)
13. [Keamanan dan produksi](#keamanan-dan-produksi)
14. [Laboratorium satu VM (opsional)](#laboratorium-satu-vm-opsional)
15. [Referensi](#referensi)

---

## Debian 13 (Trixie) dan dukungan vendor

- **Graylog** dan **MongoDB** pada umumnya mempublikasikan dukungan OS mengacu **Debian 12 (Bookworm)** di [compatibility matrix](https://go2docs.graylog.org/current/setting_up_graylog/compatibility_matrix.htm) dan [dokumentasi MongoDB untuk Debian](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian/). **Debian 13** cocok untuk **laboratorium / pembelajaran**; untuk **produksi**, utamakan kombinasi yang tercantum resmi di matriks atau gunakan Debian 12 seperti di [panduan Bookworm](../12/graylog/README.md).
- **Paket MongoDB** di bawah memakai repositori APT resmi dengan path **`bookworm/mongodb-org/8.0`** (satu-satunya jalur yang dipublikasikan MongoDB untuk paket `mongodb-org` 8.0 pada Debian). Pada host **Trixie**, praktik umum adalah memakai entri **Bookworm** tersebut sampai MongoDB menambahkan distro Trixie secara eksplisit; setelah pemasangan, uji layanan dan upgrade dengan hati-hati.
- **Graylog Data Node** mengelola **OpenSearch** sebagai backend pencarian; tidak perlu memasang paket OpenSearch terpisah jika Anda mengikuti [jalur Data Node](#data-node).
- **OpenSearch self-managed** memasang paket **`opensearch`** dan menghubungkannya lewat **`elasticsearch_hosts`**; ikuti [jalur alternatif](#jalur-alternatif-opensearch-self-managed). Jangan memakai **Data Node** dan **OpenSearch terpisah** untuk peran indeks yang sama dalam satu deployment.

---

## Pengantar

**Graylog** adalah platform manajemen log terpusat: menerima log dari berbagai sumber, memproses, mengindeks, dan menyediakan pencarian serta dashboard. **MongoDB** menyimpan metadata; **Graylog Server** menyediakan API dan antarmuka web.

- **Jalur Data Node (disarankan Graylog):** **Graylog Data Node** mengelola **OpenSearch** untuk indeks pencarian (misalnya **`opensearch_heap`** di **`/etc/graylog/datanode/datanode.conf`**). **Jangan** memasang paket OpenSearch terpisah pada jalur ini.
- **Jalur OpenSearch self-managed:** Anda memasang **OpenSearch** dari repositori resmi OpenSearch, mengonfigurasi node tersebut, lalu mengatur **`elasticsearch_hosts`** di **`/etc/graylog/server/server.conf`** agar Graylog menggunakan cluster tersebut. Rincian pemasangan mengacu [Debian Installation with Self-Managed OpenSearch](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_os.htm).

---

## Arsitektur minimal (resmi)

Panduan Debian tunggal untuk Graylog Core mengasumsikan **dua peran host**: satu untuk **Graylog + MongoDB**, satu untuk **Data Node**. Hubungan jaringan antar komponen harus dapat mencapai port yang dibutuhkan; daftar lengkap ada di dokumentasi Graylog ([Network Connectivity and Firewall Requirements](https://go2docs.graylog.org/current/setting_up_graylog/network_connectivity.htm)).

```mermaid
flowchart LR
  senders[Pengirim_log]
  gl[graylog_server]
  mongo[(MongoDB)]
  dn[graylog_datanode]
  senders --> gl
  gl --> mongo
  gl --> dn
```

Untuk klaster beberapa node Graylog, ikuti panduan terpisah: [Debian Installation: Multiple Graylog Nodes](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_multiple_nodes.htm).

---

## Prasyarat

- Debian 13 (Trixie) terpasang, akses **root** atau **sudo** (contoh di bawah memakai `sudo`; sesuaikan jika Anda login sebagai root).
- Pastikan **port** yang diperlukan terbuka antar node sesuai [persyaratan jaringan Graylog](https://go2docs.graylog.org/current/setting_up_graylog/network_connectivity.htm); panduan instalasi umum mengasumsikan firewall tidak memblokir lalu lintas yang diperlukan untuk langkah awal.
- Dokumentasi Graylog **menganjurkan filesystem XFS** untuk penyimpanan dan meninjau [rekomendasi sumber daya](https://go2docs.graylog.org/current/setting_up_graylog/core_architecture.htm) sebelum produksi.
- Cek **matriks kompatibilitas** MongoDB, OS, dan Graylog di dokumentasi Graylog untuk versi yang Anda pilih.

---

## Zona waktu

Menyetel zona waktu server (contoh **UTC**, sama seperti panduan resmi):

```sh
sudo timedatectl set-timezone UTC
```

---

## MongoDB 8.0

Ikuti [tutorial MongoDB untuk Debian](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian/) atau ringkasan berikut. Panduan Graylog mengasumsikan **MongoDB 8.0** untuk Graylog 7 — verifikasi di [compatibility matrix](https://go2docs.graylog.org/current/setting_up_graylog/compatibility_matrix.htm). Pada host Trixie, repositori APT di bawah memakai path **`bookworm`** sesuai yang dipublikasikan MongoDB untuk paket resmi (lihat [Debian 13 (Trixie) dan dukungan vendor](#debian-13-trixie-dan-dukungan-vendor)).

1. Pasang alat kunci dan unduhan:

```sh
sudo apt-get update
sudo apt-get install -y gnupg curl
```

2. Impor kunci publik MongoDB dan buat berkas sumber **`bookworm`** / **8.0**:

```sh
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
  --dearmor
```

```sh
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

3. Pasang MongoDB, tahan versi agar tidak naik otomatis saat `upgrade` besar:

```sh
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo apt-mark hold mongodb-org
```

4. Edit **`/etc/mongod.conf`**: secara bawaan MongoDB hanya mendengarkan lokal. Agar node lain (misalnya Data Node) dapat terhubung, atur **`bindIpAll: true`** atau **`bindIp`** ke alamat atau nama host tertentu (lihat [dokumentasi instalasi Graylog](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation.htm)).

Contoh mendengarkan di semua antarmuka:

```yaml
net:
  port: 27017
  bindIpAll: true
```

5. Aktifkan dan jalankan layanan:

```sh
sudo systemctl daemon-reload
sudo systemctl enable mongod.service
sudo systemctl start mongod.service
```

---

## Data Node

Pasang pada **host Data Node** (terpisah dari Graylog+MongoDB sesuai arsitektur resmi).

1. Tambahkan repositori Graylog dan pasang paket Data Node (sesuaikan URL `.deb` dengan versi minor Graylog 7 yang Anda targetkan; verifikasi di situs paket Graylog; contoh berikut mengikuti pola dokumentasi 7.0):

```sh
wget https://packages.graylog2.org/repo/packages/graylog-7.0-repository_latest.deb
sudo dpkg -i graylog-7.0-repository_latest.deb
sudo apt-get update
sudo apt-get install -y graylog-datanode
```

2. Pastikan **`vm.max_map_count`** minimal **262144**:

```sh
cat /proc/sys/vm/max_map_count
```

Jika perlu menaikkan (persisten):

```sh
echo 'vm.max_map_count=262144' | sudo tee /etc/sysctl.d/99-graylog-datanode.conf
sudo sysctl --system
cat /proc/sys/vm/max_map_count
```

Cuplikan berkas sysctl ada di [examples/sysctl-graylog-datanode.conf.example](examples/sysctl-graylog-datanode.conf.example).

3. Buat **`password_secret`** (string acak; **harus sama** nanti di Graylog Server):

```sh
openssl rand -hex 32
```

4. Edit **`/etc/graylog/datanode/datanode.conf`**:

   - Set **`password_secret`** ke nilai dari langkah di atas.
   - Tambahkan **`opensearch_heap`** (properti ini **biasanya tidak** ada di berkas bawaan dan harus ditambahkan manual). Data Node membungkus layanan **OpenSearch**; heap untuk backend pencarian diatur lewat properti ini. Dokumentasi instalasi dan antarmuka Graylog menganjurkan kira-kira **setengah RAM fisik host** untuk heap Data Node (dengan batas atas sesuai [panduan Graylog](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation.htm), misalnya hingga **31g** pada node besar). Contoh: host **31 GB** RAM dengan heap hanya **1g** dapat memicu peringatan di UI; nilai yang selaras dengan anjuran **50%** adalah **`opensearch_heap = 15g`** (bulatkan ke bawah sesuai kebijakan Anda).
   - Set **`mongodb_uri`** mengarah ke host MongoDB Anda (contoh di bawah menggabungkan dengan **`opensearch_heap`**):

```ini
mongodb_uri = mongodb://nama-host-mongodb:27017/graylog
opensearch_heap = 15g
```

5. Aktifkan dan jalankan:

```sh
sudo systemctl daemon-reload
sudo systemctl enable graylog-datanode.service
sudo systemctl start graylog-datanode
```

### Peringatan "Data Node Heap Size" di antarmuka Graylog

Graylog dapat menampilkan notifikasi bahwa satu atau lebih Data Node **dapat** berjalan dengan heap Java yang lebih besar untuk kinerja lebih baik (misalnya heap **1g** pada host ber-RAM besar). Pesan tersebut menyebut bahwa layanan Data Node membungkus **OpenSearch**, dan perubahan yang dimaksud adalah properti **`opensearch_heap`** di **`/etc/graylog/datanode/datanode.conf`** pada **setiap** host Data Node.

Setelah mengubah **`opensearch_heap`**, **restart** layanan Data Node agar pengaturan berlaku (sesuaikan jendela pemeliharaan di produksi):

```sh
sudo systemctl restart graylog-datanode
```

---

## Jalur alternatif: OpenSearch self-managed

**Sumber resmi (ikuti untuk detail dan pembaruan versi):** [Debian Installation with Self-Managed OpenSearch](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_os.htm)

Graylog mendokumentasikan pemasangan **OpenSearch** dari repositori OpenSearch dan pengaturan **`elasticsearch_hosts`** di Graylog Server. **[Graylog Data Node](https://go2docs.graylog.org/current/setting_up_graylog/data_node.htm)** tetap metode **yang disarankan** untuk mengonfigurasi dan mengoptimalkan backend pencarian terintegrasi; jalur ini untuk Anda yang mengelola cluster OpenSearch secara manual.

### Eksklusivitas dengan Data Node

Untuk satu lingkungan indeks, pilih **salah satu**: backend lewat **[Data Node](#data-node)** **atau** **OpenSearch** terpasang manual di bawah — **bukan keduanya**.

### Prasyarat versi (ringkasan Graylog 7.0.x)

Tabel berikut mengacu panduan Graylog untuk instalasi Debian dengan OpenSearch self-managed; **verifikasi** di halaman resmi jika Anda memakai versi patch berbeda:

| Graylog | MongoDB min | MongoDB max | OpenSearch min | OpenSearch max |
| ------- | ----------- | ----------- | -------------- | -------------- |
| 7.0.x   | 7.x         | 8.0.x       | 1.1.x¹         | 2.19.4         |

¹ Untuk **Graylog Security**, minimum OpenSearch dapat **2.0.x**; lihat [dokumentasi resmi](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_os.htm).

**Peringatan Graylog:** jangan memasang atau meng-upgrade ke **OpenSearch 3.0+** — tidak didukung dan dapat merusak instalasi.

### MongoDB

Pasang MongoDB seperti pada bagian [MongoDB 8.0](#mongodb-80) (biasanya pada host yang sama dengan Graylog; sesuaikan dengan desain Anda).

### Pemasangan OpenSearch (repositori resmi)

1. Paket dasar:

```sh
sudo apt-get update && sudo apt-get install -y lsb-release ca-certificates curl gnupg2
```

2. Impor kunci GPG dan tambahkan repositori APT OpenSearch **2.x**:

```sh
curl -o- https://artifacts.opensearch.org/publickeys/opensearch.pgp | sudo gpg --dearmor --batch --yes -o /usr/share/keyrings/opensearch-keyring
```

```sh
echo "deb [signed-by=/usr/share/keyrings/opensearch-keyring] https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt stable main" | sudo tee /etc/apt/sources.list.d/opensearch-2.x.list
sudo apt-get update
```

#### Jika `apt-get update` gagal: OpenSearch, sqv, dan SHA1 (Debian 13 / Trixie)

APT pada Debian **Trixie** memverifikasi tanda tangan repositori dengan **Sequoia** (`/usr/bin/sqv`). Anda dapat melihat kegagalan seperti:

- `OpenPGP signature verification failed` / `The repository ... is not signed`
- `Signing key on ... is not bound` … `SHA1 is not considered secure since 2026-02-01T00:00:00Z`

Ini berkaitan dengan kebijakan OpenPGP APT terhadap sertifikasi kunci yang masih memakai **SHA1**; kunci publik di **`artifacts.opensearch.org`** dapat memicu penolakan tersebut hingga OpenSearch memublikasikan kunci / rantai yang diperbarui (pantau juga [forum OpenSearch](https://forum.opensearch.org/t/opensearch-pgp-signature-no-longer-valid-installation-of-opensearch-fails/27947)).

**Workaround sementara (hanya untuk lab):** salin konfigurasi default Sequoia APT dan **perpanjang tanggal cutoff** untuk algoritme hash SHA1 (bukan solusi jangka panjang; hapus berkas override setelah upstream memperbaiki kunci). Prosedur ini mengikuti pola yang didokumentasikan untuk APT + Sequoia ([apt, SHA-1 keys + 2026-02-01](https://michael-prokop.at/blog/2026/01/31/apt-sha-1-keys-2026-02-01/)):

```sh
sudo mkdir -p /etc/crypto-policies/back-ends
sudo cp /usr/share/apt/default-sequoia.config /etc/crypto-policies/back-ends/apt-sequoia.config
sudo nano /etc/crypto-policies/back-ends/apt-sequoia.config
```

Di bagian **`[hash_algorithms]`**, geser tanggal setelah **2026-02-01**, misalnya:

```ini
[hash_algorithms]
sha1.second_preimage_resistance = 2027-01-01
sha224 = 2027-01-01

[packets]
signature.v3 = 2027-01-01
```

(Sesuaikan dengan isi berkas Anda; yang penting **tanggal cutoff** tidak lagi jatuh pada atau sebelum tanggal hari ini untuk kebijakan yang memicu error.)

Lalu ulangi:

```sh
sudo apt-get update
```

**DNS:** baris seperti `forward host lookup failed: Unknown server error` di awal `apt-get update` biasanya masalah **resolusi nama** (misalnya IPv6 atau DNS resolver). Periksa `/etc/resolv.conf`, konektivitas, atau coba `sudo apt-get update -o Acquire::ForceIPv4=true` jika IPv6 bermasalah.

3. (Opsional) Lihat versi yang tersedia:

```sh
sudo apt list -a opensearch
```

4. Pasang OpenSearch. Untuk **OpenSearch 2.12 dan lebih baru**, set variabel **`OPENSEARCH_INITIAL_ADMIN_PASSWORD`** saat pemasangan (sandi admin awal; syarat panjang dan kompleksitas mengacu dokumentasi Graylog/OpenSearch):

```sh
sudo OPENSEARCH_INITIAL_ADMIN_PASSWORD='GantiDenganSandiKuat9!' apt-get install -y opensearch
```

Untuk memasang versi tertentu:

```sh
sudo OPENSEARCH_INITIAL_ADMIN_PASSWORD='GantiDenganSandiKuat9!' apt-get install -y opensearch=2.15.0
```

5. Tahan paket agar tidak ter-upgrade tanpa sengaja:

```sh
sudo apt-mark hold opensearch
```

### Konfigurasi OpenSearch (contoh minimal untuk lab)

**Peringatan:** panduan Graylog untuk keadaan berjalan minimal sering memakai **tanpa** hardening keamanan penuh. Sebelum produksi: batasi jaringan, jangan mengekspos layanan ke internet, dan ikuti [Secure Your Graylog Environment](https://go2docs.graylog.org/current/setting_up_graylog/secure_your_environment.htm) serta dokumentasi keamanan OpenSearch.

1. Edit **`/etc/opensearch/opensearch.yml`** — contoh **single-node** mengikuti dokumentasi Graylog ( **`plugins.security.disabled: true`** hanya cocok untuk isolasi lab):

```yaml
cluster.name: graylog
node.name: ${HOSTNAME}
path.data: /var/lib/opensearch
path.logs: /var/log/opensearch
discovery.type: single-node
network.host: 0.0.0.0
action.auto_create_index: false
plugins.security.disabled: true
```

2. Edit **`/etc/opensearch/jvm.options`**: samakan **`-Xms`** dan **`-Xmx`** (misalnya setengah RAM host untuk lab). Lihat [Important settings](https://opensearch.org/docs/latest/install-and-configure/install-opensearch/important-settings/) OpenSearch.

3. **`vm.max_map_count`**: minimal **262144**, persisten lewat `sysctl.d` (sama kebutuhannya seperti Data Node; cuplikan ada di [examples/sysctl-graylog-datanode.conf.example](examples/sysctl-graylog-datanode.conf.example)):

```sh
echo 'vm.max_map_count=262144' | sudo tee /etc/sysctl.d/99-opensearch.conf
sudo sysctl --system
```

4. Aktifkan layanan:

```sh
sudo systemctl daemon-reload
sudo systemctl enable opensearch.service
sudo systemctl start opensearch.service
```

Pastikan host **graylog-server** dapat menjangkau HTTP OpenSearch (biasanya **9200/tcp**) — `127.0.0.1` jika se-host, atau nama host/IP jika OpenSearch di mesin lain.

Setelah OpenSearch berjalan, lanjutkan ke [Graylog Server](#graylog-server) dan ikuti [Memakai backend OpenSearch self-managed](#memakai-backend-opensearch-self-managed).

---

## Graylog Server

Pasang pada **host yang sama dengan MongoDB** dalam pola umum (node **Graylog + MongoDB**). Pastikan repositori Graylog sudah terpasang pada host ini (paket `graylog-7.0-repository_latest.deb` seperti pada Data Node), lalu pasang paket server dan konfigurasikan **`server.conf`** sesuai backend yang Anda pilih.

1. Pasang server (pilih edisi sesuai kebutuhan; untuk Graylog Open):

```sh
sudo apt-get update
sudo apt-get install -y graylog-server
```

Untuk edisi Enterprise / Security, paketnya berbeda (`graylog-enterprise`); lihat [dokumentasi pemasangan](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation.htm).

2. Buat **`root_password_sha2`**: hash SHA-256 dari kata sandi administrator web (simpan kata sandi aslinya untuk setelah preflight selesai). Contoh interaktif seperti dokumentasi resmi:

```sh
echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
```

3. Lanjutkan dengan **salah satu** subbagian berikut sebelum menjalankan Graylog Server pertama kali.

### Memakai backend Graylog Data Node

Edit **`/etc/graylog/server/server.conf`**:

   - **`root_password_sha2`** = keluaran langkah hash di atas.
   - **`password_secret`** = **sama persis** dengan di **`/etc/graylog/datanode/datanode.conf`**.
   - **`http_bind_address`**: alamat/IP untuk UI dan API, misalnya:

```ini
http_bind_address = 0.0.0.0:9000
```

   - Sesuaikan **journal** sesuai volume log yang diharapkan (contoh dari dokumentasi: umur maksimum **72h**, ukuran maksimum disesuaikan kebutuhan):

```ini
message_journal_max_age = 72h
message_journal_max_size = 90gb
```

### Memakai backend OpenSearch self-managed

Edit **`/etc/graylog/server/server.conf`** — **set properti berikut sebelum** `systemctl start graylog-server` **pertama kali**. Menurut dokumentasi Graylog, tanpa **`elasticsearch_hosts`** yang benar sebelum start awal, Anda dapat **tidak dapat masuk** dengan kata sandi root yang sudah Anda konfigurasi.

   - **`root_password_sha2`** = keluaran langkah hash di atas.
   - **`password_secret`**: buat string acak (contoh dari dokumentasi Graylog):

```sh
< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c${1:-96}; echo
```

   - **`elasticsearch_hosts`**: daftar URI (koma) ke node OpenSearch, misalnya satu node lokal:

```ini
elasticsearch_hosts = http://127.0.0.1:9200
```

   Untuk beberapa node atau skema otentikasi, lihat contoh di [dokumentasi resmi](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_os.htm) (mis. `https://user:pass@host:9200`).

   - **`http_bind_address`**, **journal** — sama seperti di [Memakai backend Graylog Data Node](#memakai-backend-graylog-data-node).

4. Edit heap Java di **`/etc/default/graylog-server`**: untuk Graylog Server, dokumentasi menganjurkan setengah memori sistem hingga batas atas yang disebutkan untuk layanan ini (misalnya maksimum **16g** — lihat “Additional Configuration” di dokumentasi Graylog). Contoh dengan min=max **2g**:

```sh
GRAYLOG_SERVER_JAVA_OPTS="-Xms2g -Xmx2g -server -XX:+UseG1GC -XX:-OmitStackTraceInFastThrow"
```

5. Tahan paket Graylog agar tidak ter-upgrade tanpa sengaja (opsional, seperti dokumentasi Graylog):

```sh
sudo apt-mark hold graylog-server
```

6. Aktifkan dan jalankan:

```sh
sudo systemctl daemon-reload
sudo systemctl enable graylog-server.service
sudo systemctl start graylog-server.service
```

---

## Gambaran pengaturan konfigurasi

Sumber utama untuk struktur berkas dan langkah lanjutan: [Configuration Settings](https://go2docs.graylog.org/current/setting_up_graylog/configuration_settings.htm) (Graylog 7.x).

| Berkas | Lokasi default | Peran singkat |
| ------ | -------------- | ------------- |
| **`server.conf`** | `/etc/graylog/server/server.conf` | Mengatur inti Graylog Server: kinerja, keamanan, koneksi ke node lain di klaster, dan banyak opsi lain. Sebagian besar nilai bawaan cukup untuk operasi normal; properti tertentu **wajib** diisi saat instalasi agar layanan jalan dan UI dapat diakses — lihat [Initial Configuration Settings](https://go2docs.graylog.org/current/setting_up_graylog/initial_configuration_settings.htm). Daftar lengkap properti: [Server Configuration Settings Reference](https://go2docs.graylog.org/current/setting_up_graylog/graylog_server_configuration_settings.htm). |
| **`elasticsearch_hosts`** (di **`server.conf`**) | — | Hanya untuk jalur **OpenSearch self-managed**: URI HTTP(S) ke satu atau lebih node OpenSearch (mis. `http://127.0.0.1:9200`). Harus diset sebelum start Graylog pertama sesuai [panduan resmi](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_os.htm). |
| **`datanode.conf`** | `/etc/graylog/datanode/datanode.conf` | Mengatur Graylog Data Node dan backend pencarian (OpenSearch) yang dikelola Data Node. Nilai bawaan umumnya memadai; penyesuaian untuk kinerja atau keamanan mengacu referensi resmi. Daftar lengkap: [Data Node Configuration Settings Reference](https://go2docs.graylog.org/current/setting_up_graylog/datanode_configuration_settings.htm). |

**Properti ganda dan lingkungan multi-node:** beberapa pengaturan muncul di **`server.conf`** dan **`datanode.conf`**. Di deployment beberapa node, pastikan nilai yang **harus sama** di semua node (misalnya rahasia bersama) benar-benar konsisten, dan nilai yang **harus unik per node** tidak tertukar. Rincian per properti ada di [Initial Configuration Settings](https://go2docs.graylog.org/current/setting_up_graylog/initial_configuration_settings.htm) dan referensi masing-masing berkas.

**Komponen tambahan** (di luar kedua berkas di atas) sering perlu disesuaikan setelah instalasi:

- **MongoDB** — metadata dan konfigurasi Graylog; sering perlu mengizinkan beberapa node Graylog mengakses basis data bersama.
- **Heap JVM** — Graylog Server, Data Node, dan komponen Java terkait membutuhkan alokasi memori yang seimbang (lihat bagian heap di panduan ini dan [Additional Configuration](https://go2docs.graylog.org/current/setting_up_graylog/additional_configuration.htm)).
- **OpenSearch** — pada jalur **Data Node**, OpenSearch dikelola lewat Data Node (disarankan Graylog). Pada jalur **self-managed**, OpenSearch dipasang sebagai paket **`opensearch`** dan dihubungkan lewat **`elasticsearch_hosts`**. Dokumentasi mencatat bahwa mulai Graylog 7.0 penggunaan **OpenSearch 1.x** **deprecated** dan akan dihapus di Graylog 8.0; jangan memakai **OpenSearch 3.0+** dengan Graylog 7.

---

## Preflight dan UI pertama

Ringkasan alur login antarmuka web. Untuk detail rilis terbaru (teks persis di log, variasi preflight), selalu rujuk [The Web Interface](https://go2docs.graylog.org/current/setting_up_graylog/web_interface.htm).

### Login pertama (preflight)

- **Jangan** memakai pada percobaan login **pertama** kata sandi teks biasa yang Anda hash menjadi **`root_password_sha2`** — itu dipakai **setelah** preflight selesai (lihat [Setelah preflight selesai](#setelah-preflight-selesai)).
- Setelah **`graylog-server`** berjalan, buka UI (misalnya `http://IP_GRAYLOG:9000`) dan ikuti alur **preflight** / penyiapan awal di browser.
- Kredensial atau petunjuk untuk langkah awal biasanya tercatat di **log** Graylog Server. Contoh melihat log untuk boot saat ini:

```sh
sudo journalctl -u graylog-server -b --no-pager
```

Mencari baris yang sering relevan (sesuaikan pola jika log Anda berbeda):

```sh
sudo journalctl -u graylog-server -b --no-pager | grep -iE 'password|preflight|initial|credential|root|admin'
```

Beberapa instalasi juga menulis ke **`/var/log/`** (misalnya di bawah `/var/log/graylog-server/`); path pasti bergantung pada versi paket. Anda dapat memeriksa berkas yang dipasang paket: `dpkg -L graylog-server | grep -E 'log|var'`.

### Setelah preflight selesai

- Login ke antarmuka web biasanya dengan nama pengguna **`admin`**.
- **Kata sandi** adalah **teks biasa** yang Anda masukkan saat membuat hash **`root_password_sha2`** (bukan string hash SHA-256 di `server.conf`). Simpan kata sandi itu saat instalasi; tanpa itu Anda tidak bisa masuk dengan akun administrator setelah preflight.

---

## Firewall dan verifikasi

- Buka port yang dipakai antar **Graylog**, **MongoDB**, dan **Data Node** sesuai [Network Connectivity and Firewall Requirements](https://go2docs.graylog.org/current/setting_up_graylog/network_connectivity.htm) (misalnya **27017/tcp** untuk MongoDB dari node yang berhak; jangan expose MongoDB ke internet publik tanpa kebijakan keras).
- Jika memakai **OpenSearch self-managed** pada host terpisah dari Graylog, izinkan **Graylog Server** menjangkau **9200/tcp** (HTTP klien ke OpenSearch) ke alamat node OpenSearch; jika se-host, lalu lintas loopback biasanya tidak memerlukan aturan firewall tambahan.
- Untuk UI Graylog (jika `http_bind_address` memakai port **9000**), uji dari klien:

```sh
nc -vz IP_GRAYLOG 9000
```

- Periksa layanan:

```sh
sudo systemctl status mongod graylog-server
```

Pada **Data Node**:

```sh
sudo systemctl status graylog-datanode
```

Pada **OpenSearch self-managed**:

```sh
sudo systemctl status opensearch
```

Buka browser ke **`http://IP_GRAYLOG:9000`** (atau skema/host yang Anda konfigurasi).

---

## Keamanan dan produksi

Panduan instalasi resmi **tidak** mengonfigurasi keamanan menyeluruh. Sebelum produksi: batasi akses jaringan, jangan mengekspos layanan internal ke internet, aktifkan **TLS** (misalnya lewat reverse proxy atau pengaturan HTTP yang didukung), dan ikuti [Secure Your Graylog Environment](https://go2docs.graylog.org/current/setting_up_graylog/secure_your_environment.htm). Untuk deployment produksi, pertimbangkan **Debian 12** atau kombinasi OS yang didukung resmi di [compatibility matrix](https://go2docs.graylog.org/current/setting_up_graylog/compatibility_matrix.htm).

---

## Laboratorium satu VM (opsional)

Untuk **pembelajaran** saja, Anda dapat memasang **MongoDB**, **Graylog Server**, dan **Graylog Data Node** pada satu mesin virtual. Ini **menyimpang** dari rekomendasi “Data Node di node terpisah”, membutuhkan **RAM** besar (jumlahkan heap Graylog + heap Data Node + sistem + MongoDB), dan tidak cocok sebagai pola produksi. Tetap ikuti urutan konfigurasi dan **`password_secret`** yang sama di kedua berkas; **`mongodb_uri`** dapat memakai `127.0.0.1` atau `localhost` jika MongoDB hanya mendengarkan lokal pada host yang sama.

Alternatif lab: **MongoDB**, **OpenSearch**, dan **Graylog Server** pada satu VM mengikuti [Jalur alternatif: OpenSearch self-managed](#jalur-alternatif-opensearch-self-managed); tetap hitung RAM untuk heap Graylog, heap OpenSearch, dan overhead sistem.

---

## Referensi

| Topik | Tautan |
| ----- | ------ |
| Gambaran berkas konfigurasi (`server.conf`, `datanode.conf`) | [Configuration Settings](https://go2docs.graylog.org/current/setting_up_graylog/configuration_settings.htm) |
| Pengaturan awal wajib / properti penting | [Initial Configuration Settings](https://go2docs.graylog.org/current/setting_up_graylog/initial_configuration_settings.htm) |
| MongoDB, heap JVM, OpenSearch (tambahan) | [Additional Configuration](https://go2docs.graylog.org/current/setting_up_graylog/additional_configuration.htm) |
| Instalasi Debian (satu node Graylog dalam arti panduan Core) | [Debian Installation: Single Graylog Node](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation.htm) |
| Instalasi Debian dengan OpenSearch self-managed | [Debian Installation with Self-Managed OpenSearch](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_os.htm) |
| APT Sequoia / kunci SHA1 (workaround cutoff 2026) | [apt, SHA-1 keys + 2026-02-01](https://michael-prokop.at/blog/2026/01/31/apt-sha-1-keys-2026-02-01/) |
| Beberapa node Graylog | [Multiple Graylog Nodes](https://go2docs.graylog.org/current/downloading_and_installing_graylog/debian_installation_multiple_nodes.htm) |
| Arsitektur Core | [Core architecture](https://go2docs.graylog.org/current/setting_up_graylog/core_architecture.htm) |
| Jaringan dan firewall | [Network Connectivity and Firewall Requirements](https://go2docs.graylog.org/current/setting_up_graylog/network_connectivity.htm) |
| Keamanan | [Secure Your Graylog Environment](https://go2docs.graylog.org/current/setting_up_graylog/secure_your_environment.htm) |
| Antarmuka web dan preflight | [The Web Interface](https://go2docs.graylog.org/current/setting_up_graylog/web_interface.htm) |
| Konfigurasi Data Node (referensi) | [Data Node Configuration Settings Reference](https://go2docs.graylog.org/current/setting_up_graylog/datanode_configuration_settings.htm) |
| Konfigurasi Graylog Server (referensi) | [Graylog Server Configuration Settings Reference](https://go2docs.graylog.org/current/setting_up_graylog/graylog_server_configuration_settings.htm) |
| Matriks kompatibilitas | [Compatibility matrix](https://go2docs.graylog.org/current/setting_up_graylog/compatibility_matrix.htm) |

Dokumentasi MongoDB untuk Debian: [Install MongoDB Community Edition on Debian](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian/).

Panduan serupa untuk **Debian 12**: [Graylog di Debian 12 (Bookworm)](../12/graylog/README.md).
