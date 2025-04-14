How to Install DeepSeek Locally with Ollama LLM in Ubuntu 24.04

Running large language models like DeepSeek locally on your machine is a powerful way to explore AI capabilities without relying on cloud services.

In this guide, we’ll walk you through installing DeepSeek using Ollama on Ubuntu 24.04 and setting up a Web UI for an interactive and user-friendly experience.

What is DeepSeek and Ollama?
    - DeepSeek: An advanced AI model designed for natural language processing tasks like answering questions, generating text, and more. .
    - Ollama: A platform that simplifies running large language models locally by providing tools to manage and interact with models like DeepSeek.
    - Web UI: A graphical interface that allows you to interact with DeepSeek through your browser, making it more accessible and user-friendly.

Prerequisites
Before we begin, make sure you have the following:
    - Ubuntu 24.04 installed on your machine.
    - A stable internet connection.
    - At least 8GB of RAM (16GB or more is recommended for smoother performance).
    - Basic familiarity with the terminal.

Step 1: Install Python and Git
Before installing anything, it’s a good idea to update your system to ensure all existing packages are up to date.
```sh
sudo apt update && sudo apt upgrade -y
```
Ubuntu likely comes with Python pre-installed, but it’s important to ensure you have the correct version (Python 3.8 or higher).
```sh
sudo apt install python3
python3 --version
```
freestar
pip is the package manager for Python, and it’s required to install dependencies for DeepSeek and Ollama.
```sh
sudo apt install python3-pip
pip3 --version
```
Git is essential for cloning repositories from GitHub.
```sh
sudo apt install git
git --version
```
Step 2: Install Ollama for DeepSeek
Now that Python and Git are installed, you’re ready to install Ollama to manage DeepSeek.
```sh
curl -fsSL https://ollama.com/install.sh | sh
ollama --version
```
Next, start and enable Ollama to start automatically when your system boots.
```sh
sudo systemctl start ollama
sudo systemctl enable ollama
```
Now that Ollama is installed, we can proceed with installing DeepSeek.

Step 3: Download and Run DeepSeek Model
Now that Ollama is installed, you can download the DeepSeek model.
```sh
ollama run deepseek-r1:7b
```
This may take a few minutes depending on your internet speed, as the model is several gigabytes in size.

Once the download is complete, you can verify that the model is available by running:
```sh
ollama list
```
You should see deepseek listed as one of the available models.

Step 4: Run DeepSeek in a Web UI
While Ollama allows you to interact with DeepSeek via the command line, you might prefer a more user-friendly web interface. For this, we’ll use Ollama Web UI, a simple web-based interface for interacting with Ollama models.

First, create a virtual environment that isolates your Python dependencies from the system-wide Python installation.
```sh
sudo apt install python3-venv
python3 -m venv ~/open-webui-venv
source ~/open-webui-venv/bin/activate
```
Now that your virtual environment is active, you can install Open WebUI using pip.
```sh
pip install open-webui
```
Once installed, start the server using.
```sh
open-webui serve
```
Open your web browser and navigate to http://localhost:8080 – you should see the Ollama Web UI interface.

Open WebUI Admin Account
Open WebUI Admin Account
In the Web UI, select the deepseek model from the dropdown menu and start interacting with it. You can ask questions, generate text, or perform other tasks supported by DeepSeek.

Running DeepSeek on Ubuntu
Running DeepSeek on Ubuntu
You should now see a chat interface where you can interact with DeepSeek just like ChatGPT.

Step 5: Enable Open-WebUI on System Boot
To make Open-WebUI start on boot, you can create a systemd service that automatically starts the Open-WebUI server when your system boots.
```sh
sudo nano /etc/systemd/system/open-webui.service
```
Add the following content to the file:
```sh
[Unit]
Description=Open WebUI Service
After=network.target

[Service]
User=your_username
WorkingDirectory=/home/your_username/open-webui-venv
ExecStart=/home/your_username/open-webui-venv/bin/open-webui serve
Restart=always
Environment="PATH=/home/your_username/open-webui-venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[Install]
WantedBy=multi-user.target
```
Replace your_username with your actual username.


freestar
Now reload the systemd daemon to recognize the new service:
```sh
sudo systemctl daemon-reload
```
Finally, enable and start the service to start on boot:
```sh
sudo systemctl enable open-webui.service
sudo systemctl start open-webui.service
```
Check the status of the service to ensure it’s running correctly:
```sh
sudo systemctl status open-webui.service
```
Running DeepSeek on Cloud Platforms
If you prefer to run DeepSeek on the cloud for better scalability, performance, or ease of use, here are some excellent cloud solutions:

Linode – It provides affordable and high-performance cloud hosting, where you can deploy an Ubuntu instance and install DeepSeek using Ollama for a seamless experience.
Google Cloud Platform (GCP) – It offers powerful virtual machines (VMs) with GPU support, making it ideal for running large language models like DeepSeek.
Conclusion
You’ve successfully installed Ollama and DeepSeek on Ubuntu 24.04. You can now run DeepSeek in the terminal or use a Web UI for a better experience.