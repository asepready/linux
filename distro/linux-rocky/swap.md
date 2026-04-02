```sh
# Step 1 – Checking the System for Swap Information
sudo swapon --show
free -h

# Step 2 – Checking Available Space on the Hard Drive Partition
df -h

# Step 3 – Creating a Swap File
sudo fallocate -l 1G /swapfile
ls -lh /swapfile

# Step 4 – Enabling the Swap File
sudo chmod 600 /swapfile
ls -lh /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
free -h

# Step 5 – Making the Swap File Permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Step 6 – Tuning your Swap Settings
#Adjusting the Swappiness Property
cat /proc/sys/vm/swappiness
sudo sysctl vm.swappiness=10
#Adjusting the Cache Pressure Setting
cat /proc/sys/vm/vfs_cache_pressure
sudo sysctl vm.vfs_cache_pressure=50

sudo sysctl --system
```
