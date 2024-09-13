#!/bin/bash

# Prompt for username and password
read -p "Enter username: " USERNAME
echo

# Update package list and upgrade existing packages
sudo apt update && sudo apt upgrade -y

# Function to check if a package is installed
is_installed() {
    dpkg -l | grep -q "$1"
}

# Install Brave Browser
if ! is_installed "brave-browser"; then
    sudo apt install -y apt-transport-https curl
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-archive-keyring.gpg stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
fi

# Install Google Chrome
if ! is_installed "google-chrome-stable"; then
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
fi

# Install Slack
if ! is_installed "slack"; then
    wget -O slack.deb https://downloads.slack.com/linux/slack-deb_4.26.2_amd64.deb
    sudo dpkg -i slack.deb
    sudo apt --fix-broken install -y
    rm slack.deb
fi

# Install IntelliJ IDEA Community Edition
if ! is_installed "idea"; then
    wget -O idea.tar.gz https://download.jetbrains.com/idea/ideaIC-2024.1.1.tar.gz
    sudo tar -xzf idea.tar.gz -C /opt
    sudo ln -s /opt/idea-IC-*/bin/idea.sh /usr/local/bin/idea
    rm idea.tar.gz
fi

# Install DBeaver
if ! is_installed "dbeaver"; then
    wget -O dbeaver.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
    sudo dpkg -i dbeaver.deb
    sudo apt --fix-broken install -y
    rm dbeaver.deb
fi

# Install MongoDB Compass
if ! is_installed "mongodb-compass"; then
    wget -O mongodb-compass_1.43.5_amd64.deb https://downloads.mongodb.com/compass/mongodb-compass_1.43.5_amd64.deb
    sudo dpkg -i mongodb-compass_1.43.5_amd64.deb
    sudo apt update
    sudo apt install -y mongodb-compass
fi

# Install Redis Server
if ! is_installed "redis-server"; then
    sudo apt install -y redis-server
fi

# Install Python 3
if ! is_installed "python3"; then
    sudo apt install -y python3 python3-pip
fi

# Install Java 11
if ! is_installed "openjdk-11-jdk"; then
    sudo apt install -y openjdk-11-jdk
fi

# Install Java 21
if ! is_installed "openjdk-21-jdk"; then
    sudo apt update
    sudo apt install -y openjdk-21-jdk
fi

# Install PostgreSQL
if ! is_installed "postgresql"; then
    sudo apt install -y postgresql postgresql-contrib
fi

# Install Git
if ! is_installed "git"; then
    sudo apt install -y git
fi

# If any application is not installed, use Snap as a fallback
install_with_snap() {
    local app_name=$1
    shift
    local additional_args="$@"

    if ! is_installed "$app_name"; then
        echo "Installing $app_name via Snap..."
        sudo snap install "$app_name" $additional_args
    else
        echo "$app_name is already installed."
    fi
}

# Try Snap installations
install_with_snap intellij-idea-community --classic
install_with_snap dbeaver-ce
install_with_snap brave
install_with_snap slack
install_with_snap postman


# Clean up
sudo apt autoremove -y
sudo apt clean

echo "Installation completed for $USERNAME!"
