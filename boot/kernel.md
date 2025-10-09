sudo apt-get install --install-recommends linux-generic
sudo apt-get install --install-recommends linux-image-generic linux-headers-generic
sudo apt-get install xserver-xorg

# downgrade kernel

# allow removal of running 5.4 kernel in the ncurses blue prompt - answer 'No'

sudo apt-get autoremove --purge 'linux-image-5.4.0-_-generic' 'linux-image-unsigned-5.4.0-_-generic' 'linux-modules-5.4.0-_-generic' 'linux-hwe-5.4-headers-5.4.0-_' linux-generic-hwe-18.04 linux-image-generic-hwe-18.04 linux-headers-generic-hwe-18.04
sudo apt-get autoremove --purge 'xserver-xorg*hwe*18.04'
