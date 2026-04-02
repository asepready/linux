# Lab access — fill in and store securely

**Do not commit real passwords or keys.** Use a password manager or keep this file local only.

| Item | Value |
|------|--------|
| Node hostname | `[e.g. pve01.lab.local]` |
| Management IP | `[e.g. 192.168.1.10]` |
| Web UI URL | `https://[IP]:8006` |
| SSH | `root@[IP]` or `[user]@[IP]` (after hardening) |
| SSH port | `[22 or custom]` |
| Root access method | `[password / key only]` |

## Optional: nested lab notes

| Item | Value |
|------|--------|
| Hypervisor | `[VMware / Hyper-V / other]` |
| vCPU / RAM for PVE VM | `[e.g. 4 vCPU / 8 GiB]` |
| Nested virt enabled | `[yes/no]` |

## First-login sanity

- [ ] Browser shows TLS warning until you trust cert or install ACME (Fase 2).
- [ ] `ssh root@<IP>` works from your admin workstation.
- [ ] `pveversion` run on the node shows expected major version.
