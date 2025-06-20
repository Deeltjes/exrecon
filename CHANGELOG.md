# 📄 CHANGELOG

All notable changes to **ExRecon** will be documented in this file.

---

## [v2.0] - 2025-06-19
### Added
- Full integration with TOR via ProxyChains4
- Modular multi-scan support (select multiple scan types at once)
- Auto dependency installation and TOR control port validation
- Firewall evasion module (MAC spoofing, TTL, optional decoy support)
- Web App scan using Nmap + Nikto combo
- Interactive result viewer with support for `bat`, `less`, `xdg-open`
- Formatted report generation in `.txt` and `.pdf`
- Anomaly detection by diffing scan summaries
- Decoy support based on Nmap version compatibility check

### Changed
- Replaced self-destruct behavior with persistent logging
- Output now stored in `$HOME/tor_scan_logs` instead of base directory
- Improved summary formatting and TOR IP tracking

### Removed
- Auto encryption and auto-delete behavior for plaintext logs

---

## [v1.0] - 2024-12-28
### Added
- Initial implementation: basic TOR quick scan via Nmap
- Log encryption using GPG
- Auto-wipe via `shred` after 10 minutes
- Simple menu for 3 scan types
- TOR circuit refresh and IP detection

---

> Maintained by **ExRecon** — for the Greater Good ❤️‍🔥
