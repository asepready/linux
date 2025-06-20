Ringkasan Ebook "Podman in Action"

1. Pengenalan Podman

Podman adalah mesin kontainer generasi berikutnya yang dirancang untuk mengatasi beberapa masalah yang ada pada Docker, terutama dalam hal keamanan dan penggunaan hak akses.
Podman memungkinkan pengguna untuk menjalankan kontainer tanpa memerlukan akses root, yang meningkatkan keamanan.

2. Perbandingan Fitur Podman dan Docker

Podman dan Docker mendukung semua gambar OCI dan Docker.
Podman memiliki antarmuka baris perintah (CLI) yang mirip dengan Docker, tetapi juga mendukung mode rootless dan integrasi dengan systemd.
Podman tidak memerlukan daemon yang berjalan, sedangkan Docker menggunakan model klien-server.

3. Penggunaan Kontainer dan Gambar

Kontainer adalah proses yang berjalan dalam lingkungan terisolasi, sedangkan gambar adalah snapshot dari kontainer yang dapat dibagikan.
Podman memungkinkan pengguna untuk menarik, menjalankan, dan membangun kontainer dengan mudah.

4. Volume dalam Kontainer

Volume digunakan untuk memisahkan data dari aplikasi yang berjalan dalam kontainer, memungkinkan data untuk disimpan dan dikelola secara terpisah.
Podman mendukung berbagai jenis volume, termasuk bind mounts dan named volumes.

5. Konsep Pod

Pod adalah grup dari satu atau lebih kontainer yang berbagi sumber daya dan namespace.
Podman memungkinkan pengguna untuk mengelola beberapa kontainer sebagai satu kesatuan, yang memudahkan pengelolaan aplikasi yang lebih kompleks.

6. Integrasi dengan Systemd

Podman dapat berjalan dalam mode systemd, memungkinkan pengguna untuk mengelola kontainer sebagai layanan sistem.
Systemd dapat digunakan untuk memulai dan menghentikan kontainer secara otomatis saat booting.

7. Keamanan dan Rootless Containers

Podman mendukung mode rootless, yang memungkinkan pengguna untuk menjalankan kontainer tanpa hak akses root, meningkatkan keamanan.
Penggunaan namespace pengguna dan mount namespace membantu dalam isolasi dan keamanan kontainer.

8. Konfigurasi dan Kustomisasi

Podman menyediakan berbagai file konfigurasi untuk mengatur perilaku mesin kontainer, termasuk pengaturan untuk penyimpanan, registri, dan opsi lainnya.
Pengguna dapat menyesuaikan pengaturan default sesuai dengan kebutuhan lingkungan mereka.

Kesimpulan Ebook ini memberikan panduan komprehensif tentang penggunaan Podman, termasuk cara mengelola kontainer, gambar, volume, dan integrasi dengan sistem operasi. Podman menawarkan alternatif yang lebih aman dan fleksibel dibandingkan dengan Docker, terutama dalam konteks penggunaan di lingkungan yang memerlukan kontrol akses yang ketat.

####################################################################################################

1. Instalasi Podman
   Instal Podman di sistem Anda:

```sh
# Untuk Fedora
sudo dnf install podman

# Untuk Ubuntu/Debian
sudo apt-get install podman

# Untuk CentOS/RHEL
sudo yum install podman
```

2. Menjalankan Kontainer

```sh
# Menjalankan kontainer dari gambar Docker:
podman run -d --name mycontainer quay.io/rhatdan/myimage

# Menjalankan kontainer dengan port mapping:
podman run -d -p 8080:80 --name webserver quay.io/rhatdan/myimage

# Konsole ke dalam kontainer
podman exec -ti webserver /bin/sh
```

2.1 Jenis-Jenis Restart Policy

```sh
# Podman mendukung beberapa jenis restart policy, yaitu:
## no | Tidak ada restart otomatis. Default jika tidak ditentukan.
## on-failure[:max] | Restart hanya jika container keluar dengan status error (non-zero exit code). Opsi :max opsional untuk membatasi jumlah percobaan restart.
## always | Selalu restart container tanpa syarat, termasuk setelah host reboot.
## unless-stopped | Restart container kecuali container dihentikan secara manual oleh pengguna.

podman run -d -p 8080:80 --name webserver --restart=no quay.io/rhatdan/myimage
# or
podman run -d -p 8080:80 --name webserver --restart=always quay.io/rhatdan/myimage
# or
podman run -d -p 8080:80 --name webserver --restart=on-failure:5 quay.io/rhatdan/myimage
# or
podman run -d -p 8080:80 --name webserver --restart=unless-stopped quay.io/rhatdan/myimage
```

3. Menggunakan Volume

```sh
# Membuat volume:
podman volume create myvolume

# Menjalankan kontainer dengan volume:
podman run -d -v myvolume:/app --name myapp quay.io/rhatdan/myimage
```

4. Membuat dan Mengelola Pod

```sh
# Membuat pod:
podman pod create --name pod-hello -p 8080:80 -p 8443:443

# Menambahkan kontainer ke dalam pod:

mkdir -p html
echo "Hello World" > ./html/index.html
podman run -d --pod pod-hello --name hello-container \
  -v ./html:/var/www/html:Z \
  docker.io/library/php:7.4-apache

# Melihat daftar pod:
podman pod list
```

5. Integrasi dengan Systemd

```sh
# Membuat unit file systemd untuk kontainer:
sudo vi /etc/systemd/system/myapp.service

# Isi file unit:
[Unit]
Description=My Podman Container

[Service]
Restart=always
ExecStart=/usr/bin/podman start -a myapp
ExecStop=/usr/bin/podman stop -t 10 myapp

[Install]
WantedBy=multi-user.target

# Mengaktifkan dan memulai layanan:
sudo systemctl enable myapp.service
sudo systemctl start myapp.service
```

6. Mengelola Gambar

```sh
# Menarik gambar dari registri:
podman pull quay.io/rhatdan/myimage

# Melihat daftar gambar:
podman images

# Menghapus gambar:
podman rmi quay.io/rhatdan/myimage

# Mmembuat Gamabar
echo 'FROM docker.io/library/alpine:3.16
LABEL Maintainer="Asep Ready <asepready@gmail.com>"
LABEL Description="NGINX container based on Alpine Linux"
RUN apk add --update nginx && \
  rm -rf /var/cache/apk/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]' > Containerfile

podman build -t nginx .

podman run -d --name nginx-container -p 8080:80 localhost/nginx:latest
```

7. Menggunakan Rootless Mode

```sh
# Menjalankan kontainer tanpa hak akses root:
podman run --userns=keep-id -d quay.io/rhatdan/myimage
```

8. Mengkonfigurasi Podman

```sh
# Mengedit file konfigurasi penyimpanan:
sudo vi /etc/containers/storage.conf

# Ubah graphroot untuk menentukan lokasi penyimpanan:
graphroot = "/var/lib/containers/storage"
```

9. Mengecek Status dan Log

```sh
# Melihat daftar kontainer yang sedang berjalan:
podman ps

# Melihat log kontainer:
podman logs myapp
```

10. Menghentikan dan Menghapus Kontainer

```sh
# Menghentikan kontainer:
podman stop myapp

# Menghapus kontainer:
podman rm myapp
```

11. Membangun Gambar dari Dockerfile

```sh
# Membangun gambar dari Dockerfile:
podman build -t myimage:latest .

# Menjalankan kontainer dari gambar yang baru dibangun:
podman run -d --name myapp myimage:latest
```

12. Menggunakan Podman Compose

```sh
# Instal Podman Compose:
sudo dnf install podman-compose

# Menjalankan aplikasi dengan Podman Compose:
podman-compose up -d
```

Kesimpulan
Skrip dan perintah di atas mencakup berbagai aspek penggunaan Podman, mulai dari instalasi, menjalankan kontainer, mengelola pod, hingga integrasi dengan systemd. Jika ada bagian tertentu dari ebook yang ingin Anda eksplor lebih dalam, silakan beri tahu! Mari kita lanjutkan belajar bersama!
