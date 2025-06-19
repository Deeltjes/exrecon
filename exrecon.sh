#!/bin/bash

echo "=== ExRecon : Ultimate TOR Nmap Automation ==="
read -p "Target Domain/IP: " target

echo "Scan type:"
echo "1) TOR Quick Scan"
echo "2) TOR Service Detection"
echo "3) TOR UDP Scan + Vuln Detection"
read -p "Select (1-3): " scan_type

timestamp=$(date +%s)
output_dir="$HOME/.tor_scan_logs"
output_file="$output_dir/scan_$timestamp.txt"
mkdir -p "$output_dir"

# Start TOR if not running
if ! pgrep -x tor >/dev/null; then
  echo "[*] Starting TOR..."
  sudo systemctl start tor
  sleep 5
fi

# Request new TOR identity
echo "[*] Requesting new TOR circuit..."
echo -e 'AUTHENTICATE ""\nSIGNAL NEWNYM\nQUIT' | nc 127.0.0.1 9051 >/dev/null
sleep 5

# Confirm TOR connection (primary and backup)
if ! proxychains4 curl -s https://check.torproject.org/ | grep -q "Congratulations" && \
   ! proxychains4 curl -s https://api.ipify.org?format=json | grep -q '"ip"'; then
  echo "[!] TOR is not routing traffic. Aborting."
  exit 1
fi

tor_ip=$(proxychains4 curl -s https://api.ipify.org)
echo "[+] Active TOR Exit IP: $tor_ip"

# Generate random decoys
decoy_list=$(for i in {1..5}; do echo -n "$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255)),"; done | sed 's/,$//')

ua_string="Mozilla/5.0 (KaliGPT/NmapStealth)"

# Scan logic
case $scan_type in
  1)
    proxychains4 nmap -sT -Pn -n --top-ports 100 -T2 \
      --data-length 50 --decoy "$decoy_list" -f \
      --dns-servers 8.8.8.8 \
      -oN "$output_file" "$target"
    ;;
  2)
    proxychains4 nmap -sT -Pn -sV -T2 --script=banner,http-title,http-enum,ssl-cert \
      --script-args http.useragent="$ua_string" \
      --data-length 100 --decoy "$decoy_list" -f \
      --dns-servers 8.8.8.8 \
      -oN "$output_file" "$target"
    ;;
  3)
    proxychains4 nmap -sU -sV -Pn --script vuln \
      --data-length 120 --decoy "$decoy_list" -f \
      -T2 -oN "$output_file" "$target"
    ;;
  *)
    echo "[!] Invalid option."
    exit 1
    ;;
esac

# Encrypt scan output
echo "[*] Encrypting scan results..."
gpg --symmetric --cipher-algo AES256 --batch --yes --output "$output_file.gpg" "$output_file"
if [ $? -ne 0 ]; then
  echo "[!] GPG encryption failed. Exiting."
  exit 1
fi

# Generate SHA256 hash
echo "[*] Creating checksum..."
sha256sum "$output_file.gpg" > "$output_file.gpg.sha256"

# Shred plaintext
shred -u "$output_file" || echo "[!] Failed to shred plaintext log."

# Log summary
echo "[TOR SCAN @ $timestamp] Exit IP: $tor_ip | Target: $target | Output: scan_$timestamp.txt.gpg" >> "$output_dir/log_summary.txt"
gpg --yes --batch --symmetric --cipher-algo AES256 "$output_dir/log_summary.txt"
shred -u "$output_dir/log_summary.txt" || echo "[!] Failed to shred summary."

# Self-destruct scan results with system log notification
(sleep 600 && shred -u "$output_file.gpg" "$output_file.gpg.sha256" && logger "[+] ExRecon: Encrypted scan log $output_file.gpg has been wiped.") &

# Optional: Create a tmux session to echo deletion notice
if command -v tmux >/dev/null; then
  tmux new-session -d -s exrecon_log 'sleep 600; echo "[!] Encrypted log auto-wiped."; sleep 5; exit'
fi

echo "[+] Scan complete and encrypted. Output: $output_file.gpg (auto-wipe in 10 min)"
