# Update the System
sudo apt update && sudo apt upgrade -y
# Install Required Dependencies
sudo apt install python3 python3-pip python3-venv git -y

# installing Ollama Service
curl -fsSL https://ollama.com/install.sh | sh
ollama --version

# Systemd Service File
sudo systemctl start ollama
sudo systemctl enable ollama

# Download and Install Ollama Models
ollama run deepseek-r1:7b
ollama list

