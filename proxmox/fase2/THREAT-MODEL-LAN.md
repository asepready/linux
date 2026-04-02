# Threat model: “What if the LAN is hostile?” (Fase 2 exit)

Fill in. Goal: clarify **trust boundaries**, not perfect security.

## Assets to protect

| Asset | Why it matters |
|-------|----------------|
| PVE root / API | Full control over VMs and data |
| Guest workloads | Data integrity, lateral movement |
| Backups | Ransomware / exfiltration target |

## Adversary assumptions

| Question | Your answer |
|----------|-------------|
| Could another device on the same VLAN ARP-spoof or scan? | |
| Is Wi-Fi guest network bridged to server VLAN? | |
| Who can reach port 22 / 8006 today? | |

## Controls in place (after hardening)

| Control | Status |
|---------|--------|
| SSH keys only / no root password login | |
| Firewall limiting 8006 and SSH to admin subnet | |
| Separate management VLAN (Fase 3 if not now) | |
| Least-privilege PVE users | |
| TLS on UI / trusted cert | |

## Residual risk (one paragraph)

*(What is still acceptable risk in your lab vs what you would fix before production?)*

---
