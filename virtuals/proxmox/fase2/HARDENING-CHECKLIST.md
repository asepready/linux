# Fase 2 — Security hardening checklist

Apply on a **lab** first; document every change for rollback.

## 1. Users and realms

- [ ] Create non-root Linux user(s) with `sudo` for daily admin (Debian on PVE).
- [ ] In **Datacenter → Permissions → Users**: define operators; avoid shared accounts.
- [ ] In **Datacenter → Permissions**: use **groups** and **roles** (e.g. `PVEVMAdmin` scoped to a pool).
- [ ] Document **who** has **PVEAdmin** or equivalent (minimum people).

## 2. SSH

- [ ] **Key-based** login for admins; disable password auth if policy allows:
  - `/etc/ssh/sshd_config`: `PasswordAuthentication no`, `PermitRootLogin prohibit-password` (or `no` if you use sudo user only).
- [ ] Change default port **only** with matching firewall rules and client config (`~/.ssh/config`).
- [ ] Optional: `fail2ban` or equivalent for SSH (install from Debian repos; tune jails).

## 3. Web UI and API (`pveproxy`)

- [ ] Replace or trust certificate: **Datacenter → Certificates** — upload CA or use **ACME** if you have public DNS pointing to the node.
- [ ] Restrict **8006** to management VLAN or firewall if possible (see Fase 3).

## 4. API tokens (automation prep for Fase 6)

- [ ] Create **API token** under a dedicated user with **least privilege** (only after you know required paths).
- [ ] Store token only in secret store or `chmod 600` file — never in git.

## 5. Host firewall (baseline)

Proxmox can use `nftables`/`iptables`; many sites use **Datacenter/Host firewall** in UI. Pick one coherent model.

- [ ] **Default deny** on INPUT from untrusted networks; allow SSH + 8006 from admin subnets only.
- [ ] Log dropped packets initially (rate-limited) to validate rules.
- [ ] Document **order** of rules (cluster joins need correct corosync ports later — Fase 4).

## 6. Updates and CVE response

- [ ] Subscribe to [Proxmox VE announce](https://lists.proxmox.com/cgi-bin/mailman/listinfo/pve-announce) or check security advisories.
- [ ] **Monthly** (or weekly in lab): `apt update && apt list --upgradable`; plan `full-upgrade` in a window.
- [ ] After kernel update: **reboot** when prompted; verify cluster/VMs if in production.

## 7. Secrets hygiene

- [ ] No secrets in shell history; use `env` files with permissions or secret manager.
- [ ] Rotate API tokens when people leave or after incident.

## Exit criteria

- [ ] [THREAT-MODEL-LAN.md](THREAT-MODEL-LAN.md) filled (short).
- [ ] SSH and user model documented in [../fase0/ACCESS.md](../fase0/ACCESS.md) (update non-sensitive fields only).
