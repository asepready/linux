# One-page reinstall runbook (Fase 0 exit)

**Goal:** Rebuild the Proxmox node from scratch in under one hour.

## 0. Before you wipe

1. Export or note **VM/LXC IDs** and **storage layout** (screenshot Datacenter → Storage).
2. If anything must survive, run a **backup** to external media or another host (Fase 5); this runbook assumes a disposable lab.
3. Note **network**: management IP, gateway, DNS, bridge name (usually `vmbr0`).

## 1. Boot installer

1. Boot Proxmox VE ISO (UEFI if your hardware uses EFI).
2. Accept target disk; use **ZFS** or **ext4** per your Fase 5 plan (lab: either is fine).
3. Set **country**, **timezone**, **keyboard**.
4. Set **root password** and **email** (for notifications).
5. Set **management network**: hostname, IP (static recommended), gateway, DNS.

## 2. First boot

1. Log in on console or SSH: `root@<new-ip>`.
2. Confirm version: `pveversion -v`.
3. Optional lab: enable no-subscription repo if you are not using a subscription (see Proxmox wiki for your major version).

## 3. Post-install baseline

```bash
apt update && apt full-upgrade -y
```

Reboot if a new kernel was installed.

## 4. Document access

Copy [ACCESS.md](ACCESS.md) to this host’s values and store outside this repo if it contains secrets.

## 5. Done when

- [ ] Web UI loads at `https://<IP>:8006`.
- [ ] SSH works.
- [ ] You recorded hostname, IP, and repo choice in your notes.

**Time target:** ≤ 60 minutes including download time if ISO is already cached.
