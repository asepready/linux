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

# Moving rootless storage

Podman uses two storage locations, depending on the mode you’re using.

In rootful mode, all containers and container-related storage is in `/var/lib/containers/storage`. In rootless mode, this changes to the users home directory: `/home/<user>/.local/share/containers/storage`.

```sh
sudo mkdir -p /var/lib/containers/user/podman/storage
sudo chmod 0711 /var/lib/containers /var/lib/containers/user
sudo chmod -R 0700 /var/lib/containers/user/podman
sudo chown -R podman:podman /var/lib/containers/user/podman

```

## SeLinux on RHEL/Rocky

Checking /etc/selinux/targeted/contexts/files/file_contexts, I found out which additional selinux contexts I had to add to the newly created directories:

```sh
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2-images(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay2-layers(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay-layers(/.*)?'
sudo semanage fcontext --add --type container_ro_file_t '/var/lib/containers/user/[^/]+/storage/overlay-images(/.*)?'
sudo semanage fcontext --add --type container_file_t    '/var/lib/containers/user/[^/]+/storage/volumes/[^/]*/.*'

```
