#!/bin/bash

# === ExRecon Installer Script ===
# Description: Installs all dependencies required for the ExRecon TOR Nmap Automation script.

set -e

echo "[+] Updating package lists..."
sudo apt update

# Install dependencies
REQUIRED_PACKAGES=(
  nmap
  tor
  proxychains4
  curl
  gpg
  netcat
  tmux
  coreutils
  openssl
  macchanger
)

echo "[+] Installing required packages: ${REQUIRED_PACKAGES[*]}"
sudo apt install -y "${REQUIRED_PACKAGES[@]}"

# Ensure TOR ControlPort is enabled
TORRC_PATH="/etc/tor/torrc"
echo "[+] Ensuring TOR ControlPort is configured..."
if ! grep -q "^ControlPort 9051" "$TORRC_PATH"; then
  echo "ControlPort 9051" | sudo tee -a "$TORRC_PATH"
fi
if ! grep -q "^CookieAuthentication 0" "$TORRC_PATH"; then
  echo "CookieAuthentication 0" | sudo tee -a "$TORRC_PATH"
fi

echo "[+] Restarting TOR service..."
sudo systemctl restart tor

# Final checks
echo "[+] Validating tools..."
for tool in nmap proxychains4 curl gpg nc tmux; do
  if ! command -v "$tool" >/dev/null; then
    echo "[!] $tool is not installed properly."
    exit 1
  fi
  echo "[+] $tool is present."
done

echo "[+] All dependencies installed successfully. ExRecon is ready to run!"
