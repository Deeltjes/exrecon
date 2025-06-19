#!/bin/bash

echo "=== ExRecon : Ultimate TOR Nmap Automation ==="
read -p "Target Domain/IP: " target

echo "Scan type:"
echo "1) TOR Quick Scan"
echo "2) TOR Service Detection"
echo "3) TOR UDP Scan + Vuln Detection"
read -p "Select (1-3): " scan_type

timestamp=$(date +%s)
output_file="$HOME/scan_$timestamp.txt"

# Start TOR if not running
if ! pgrep -x tor >/dev/null; then
  echo "[*] Starting TOR..."
  sudo systemctl start tor
  sleep 5
fi

# Request new TOR circuit
echo "[*] Requesting new TOR circuit..."
echo -e 'AUTHENTICATE ""\nSIGNAL NEWNYM\nQUIT' | nc 127.0.0.1 9051 >/dev/null
sleep 5

# TOR routing check
echo "[*] Verifying TOR routing..."
tor_check=$(proxychains4 curl -s https://check.torproject.org | grep -q "Congratulations" && echo OK)
if [[ $tor_check != "OK" ]]; then
  echo "[!] TOR is not routing traffic. Aborting."
  exit 1
fi

# Adjust scan settings based on privileges
if [[ $EUID -eq 0 ]]; then
  scan_flag="-sS"
  decoys="-D$decoy_list"
  packet_frag="-f"
else
  scan_flag="-sT"
  decoys=""
  packet_frag=""
  echo "[!] Not running as root. Disabling fragment packets and decoys."
fi


# Get TOR exit IP
tor_ip=$(proxychains4 curl -s https://icanhazip.com || echo "Unavailable")
echo "[+] Active TOR Exit IP: $tor_ip"

# Random decoys and headers
decoy_list=$(for i in {1..5}; do echo -n "$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255)),"; done | sed 's/,$//')
ua_string="Mozilla/5.0 (KaliGPT/NmapStealth)"


# Run scan based on type
case $scan_type in
  1)
    proxychains4 nmap $scan_flag -Pn -n --top-ports 100 -T2 \
      --data-length 50 $decoys $packet_frag \
      --dns-servers 8.8.8.8 \
      -oN "$output_file" "$target"
    ;;
  2)
    proxychains4 nmap $scan_flag -Pn -sV -T2 \
      --script=banner,http-title,http-enum,ssl-cert \
      --script-args http.useragent="$ua_string" \
      --data-length 100 $decoys $packet_frag \
      --dns-servers 8.8.8.8 \
      -oN "$output_file" "$target"
    ;;
  3)
    proxychains4 nmap -sU -sV -Pn --script vuln -T2 \
      --data-length 120 $decoys $packet_frag \
      -oN "$output_file" "$target"
    ;;
  *)
    echo "[!] Invalid option."
    exit 1
    ;;
esac

# Confirm and log result
if [ ! -f "$output_file" ]; then
  echo "[!] Scan failed or output file missing."
  exit 1
fi

echo "[TOR SCAN @ $timestamp] Exit IP: $tor_ip | Target: $target | Output: scan_$timestamp.txt" >> "$HOME/scan_log.txt"
echo "[+] Scan complete. Output: $output_file"
