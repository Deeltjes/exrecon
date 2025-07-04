#!/bin/bash

# === ExRecon Dependencies Installer ===
# Installs all required tools for ExRecon to function.

set -e

echo "[+] Updating package list..."
sudo apt update
sudo apt upgrade

# Required tools
packages=(
  nmap
  tor
  proxychains4
  curl
  gpg
  netcat-openbsd
  tmux
  coreutils
  openssl
  enscript
  ghostscript
  pandoc
  nikto
)

echo "[+] Installing packages: ${packages[*]}"
sudo apt install -y "${packages[@]}"

# Ensure TOR control config
TORRC="/etc/tor/torrc"
if ! grep -q "^ControlPort 9051" "$TORRC"; then
  echo "ControlPort 9051" | sudo tee -a "$TORRC"
fi
if ! grep -q "^CookieAuthentication 0" "$TORRC"; then
  echo "CookieAuthentication 0" | sudo tee -a "$TORRC"
fi

echo "[+] Restarting TOR service..."
sudo systemctl restart tor

echo "[✓] All dependencies installed. ExRecon is ready to go."
