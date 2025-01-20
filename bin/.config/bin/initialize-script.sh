#!/bin/bash

# Install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

# Function to install starship
install_starship() {
    curl -sS https://starship.rs/install.sh | sh -s -- -y
}

# Function to install fd
install_fd() {
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y fd-find
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y fd-find
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm fd
    else
        echo "Unsupported package manager. Please install fd manually."
    fi
}

# Function to install ripgrep (rg)
install_ripgrep() {
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y ripgrep
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y ripgrep
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm ripgrep
    else
        echo "Unsupported package manager. Please install ripgrep manually."
    fi
}

install_zsh() {
  if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y zsh
  elif command -v dnf &> /dev/null; then
    sudo dnf install -y zsh
  elif command -v pacman &> /dev/null; then
    sudo pacman -Syu --noconfirm zsh
  else
    echo "Unsupported package manager. Please install zsh manually."
  fi
}

# Install starship
install_starship

# Install fd
install_fd

# Install ripgrep
install_ripgrep

install_zsh

echo "Installation complete."
