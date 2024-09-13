#!/bin/bash

# Prompt for username and password
read -p "Enter username: " USERNAME
read -sp "Enter password: " PASSWORD
echo

# Update package list and upgrade all packages
sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install -y \
    git \
    python3 \
    openjdk-11-jdk \
    redis-server

# Add repositories and install specific applications
# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install -y

# Brave Browser
sudo apt install -y apt-transport-https curl
sudo curl -fsSLo /etc/apt/trusted.gpg.d/brave.asc https://brave.com/brave-core.asc
sudo sh -c 'echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com stable main" > /etc/apt/sources.list.d/brave-browser.list'
sudo apt update
sudo apt install -y brave-browser

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

# Slack
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.29.159-amd64.deb
sudo dpkg -i slack-desktop-4.29.159-amd64.deb
sudo apt --fix-broken install -y

# MongoDB Compass
wget https://downloads.mongodb.com/compass/mongodb-compass_1.32.1_amd64.deb
sudo dpkg -i mongodb-compass_1.32.1_amd64.deb
sudo apt --fix-broken install -y

# Clean up downloaded .deb files
rm google-chrome-stable_current_amd64.deb
rm slack-desktop-4.29.159-amd64.deb
rm mongodb-compass_1.32.1_amd64.deb

echo "Installation completed for $USERNAME!"

