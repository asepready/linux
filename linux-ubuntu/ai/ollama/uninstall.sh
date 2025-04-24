# Uninstalling Ollama Service
# Stopping the Service
sudo systemctl stop ollama

# Disabling the Service
sudo systemctl disable ollama

# Removing the Service File
sudo rm /etc/systemd/system/ollama.service

# Deleting the Ollama Binary
sudo rm $(which ollama)

# Cleaning Up Models and User Data
sudo rm -r /usr/share/ollama
sudo groupdel ollama
sudo userdel ollama
