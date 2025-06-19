
# 🛡️ ExRecon - Ultimate TOR Nmap Automation

**ExRecon** is a stealth-oriented reconnaissance and scanning utility designed for Kali Linux. It automates advanced Nmap scans over the TOR network, encrypts logs, verifies anonymity, and self-destructs sensitive files to maximize OPSEC.

---

## ⚙️ Features

 - 🔒 Routes all scans via TOR using ProxyChains4
 - 🎭 Generates random decoy IP addresses
 - 📜 Supports multiple scan modes:
 - Quick TCP Scan (Top 100 ports)
 - Service Detection with NSE
 - UDP & Fragmentation + optional vulnerability scripts
 - 🧼 Secure self-destruction of logs after 10 minutes
 - 📡 TOR exit node verification with failover
 - 🧾 Logging via `logger` and `tmux` for event notification

---

## 🛠️ Dependencies

The following packages are required:

- `nmap`
- `proxychains4`
- `tor`
- `curl`
- `gpg`
- `tmux`
- `logger`
- `netcat` or `nc`
- `openssl`

---

## 🔧 Installation

Run the installer to set up dependencies and permissions:

```bash
chmod +x exrecon-install.sh
sudo ./exrecon-install.sh
```

---

## ⚙️ What will Installer Do

1. Ensure dependencies (nmap, proxychains4, tor, curl, nc) are installed
2. Configure /etc/proxychains4.conf to use TOR
3. Set executable permissions

---

## 🚀 Usage

```bash
chmod +x exrecon.sh
./exrecon.sh
```

1. Enter your target domain or IP address.
2. Choose a scan type.
3. Sit back and let ExRecon handle TOR, decoys, scanning, encryption, and cleanup.

---

## 📁 Output

- Scan logs saved in: `/home/kali/`

---

## 🔐 Notes

1. Run as root for SYN scans and decoy mode.
2. Ensure TOR is active; the script auto-starts it if needed.
3. All traffic is routed through TOR via proxychains4.

---

## ⚠️ Legal Warning

This tool is intended for **educational and authorized penetration testing** only. Do not use it on networks or systems you do not own or have explicit written permission to test.

---

## 📜 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 🧠 Author
ExRecon
Developed as part of the Offensive Security (The Grater Good) ❤️‍🔥❤️‍🔥❤️‍🔥
