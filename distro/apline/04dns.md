# Bind9
## Install Paket Bind
```sh
apk add --allow-untrusted bind
```
Lakukan buat konfigurasi file seperti berikut ini:
```t
/etc/
├── bind/
│   ├── db.root
│   ├── named.conf
│   └── pri/
│   │   ├── db.127
│   │   ├── db.local
│   │   └── db.asepready

```
- [lihat file named.conf](./dns/bind9/named.conf)(./dns/bind9/named.conf)
- [lihat file db.root](./dns/bind9/db.root)(./dns/bind9/db.root)
- [lihat file db.127](./dns/bind9/pri/db.127)(./dns/bind9/pri/db.127)
- [lihat file db.local](./dns/bind9/pri/db.local)(./dns/bind9/pri/db.local)
- [lihat file db.asepready](./dns/bind9/pri/db.asepready)(./dns/bind9/pri/db.db.asepready)

Jalan Server
Pertama, cek hasil kunfigurasi:
```sh
named-checkconf /etc/bind/named.conf
```
Akhiri, memulai dan aktifkan saat memulai boot:
```sh
rc-service named start
rc-update add named
```