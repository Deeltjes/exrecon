# 🛡️ ExRecon - Ultimate TOR Nmap Automation

ExRecon is a stealth-oriented reconnaissance and scanning utility designed for **Kali Linux**. It automates advanced Nmap scans over the **TOR network**, validates anonymity, logs results in clean summaries, and allows optional log viewing — all while supporting multiple recon modes.

---

## ⚙️ Features

| Capability            | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| **TOR integration**  | Routes all scans through TOR using proxychains4, and rotates exit nodes     |
| **Auto dependency check** | Detects and installs required tools like Nmap, Nikto, TOR, enscript, and more |
| **Modular scans**     | User selects multiple scan types simultaneously                             |
| **Service detection** | Uses Nmap scripts and custom UA strings to detect services behind firewalls  |
| **Firewall evasion**  | Spoofs MAC address, modifies TTL, and optionally uses decoys                 |
| **Nikto web audit**   | Launches Nikto after detecting HTTP/HTTPS ports                              |
| **Live result viewer**| Lets the user preview results using bat, less, or xdg-open                   |
| **Formatted reporting**| Generates .txt and .pdf scan summaries with deltas vs previous scan         |
| **Version-aware decoys**| Uses --decoy only if supported by the installed Nmap version               |

---

## 🛠️ Dependencies

ExRecon automatically checks and installs the following:
- `nmap`
- `proxychains4`
- `tor`
- `curl`
- `gpg`
- `tmux`
- `netcat-openbsd`
- `openssl`
- `enscript`
- `ghostscript`
- `pandoc`
- `nikto`

---

## 🔧 Installation

```bash
chmod +x exrecon.sh
./exrecon.sh
```

On first run, ExRecon will:
- Ensure all required tools are installed
- Patch `/etc/tor/torrc` to allow TOR control via `ControlPort`
- Rotate TOR circuits before each scan
- Create log storage directory `~/tor_scan_logs`

---

## 🚀 Usage

```bash
./exrecon.sh
```

- Enter target domain or IP when prompted
- Select one or more scan modes (comma-separated)
- Wait for scan to finish and optionally view results

---

## 📁 Output Directory

```
~/tor_scan_logs/
```

- Raw scan logs: `scan_<timestamp>.*`
- Summary Report: `scan_summary_<timestamp>.txt`
- Printable PDF: `scan_summary_<timestamp>.pdf`
- Anomaly comparison: `scan_summary_<timestamp>.delta`

---

## 🔐 Notes

- 🔑 Run as root for full feature access (SYN scans, MAC spoofing)
- 🚦 TOR is validated before every scan; circuit is rotated
- 🌐 All traffic is routed via TOR using ProxyChains
- 🧹 Self-destruct functionality has been disabled in this version for report preservation

---

## ⚠️ Legal Warning

**ExRecon is intended strictly for educational and authorized penetration testing purposes.**

⚠️ Do **not** use this tool against systems/networks you do not own or lack **explicit written permission** to test. Misuse can result in criminal charges.

---

## 📜 License

MIT License — see `LICENSE` file for details.

---

## 🧠 Author

**ExRecon** developed by **ExRecon** as part of Offensive Security tooling — *for the Greater Good*. ❤️‍🔥

> "Master Kali Linux, Excel in Offensive Security"
