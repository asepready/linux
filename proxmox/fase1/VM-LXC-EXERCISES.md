# Fase 1 — VM and LXC exercises

## Exercise A: Linux VM (QEMU)

1. **Create** a new VM (e.g. ID `100`), Debian or Ubuntu cloud image or ISO install.
2. **Disk:** virtio-scsi or virtio-blk; **network:** virtio on `vmbr0`.
3. **CPU:** `host` or `kvm64` for lab; note NUMA only if your host has multiple sockets.
4. **Optional:** Add **cloud-init** drive if using a cloud image (see Proxmox wiki for your version).
5. **Start** VM; install or cloud-init; verify SSH from your LAN.

**Record:** VMID `___`, OS `___`, disk GB `___`, IP `___`.

## Exercise B: LXC container

1. **Download** a template: UI **Node → local → CT Templates** or `pveam update && pveam available` on shell.
2. **Create** CT (e.g. ID `200`), **unprivileged** unless you have a specific need for privileged.
3. **Resources:** modest CPU/RAM; rootfs on `local-lvm` or your chosen storage.
4. **Start** CT; `pct enter <vmid>` or SSH if you installed openssh inside.

**Record:** CT ID `___`, template `___`, IP `___`.

## Exercise C: One simple service each

Pick **different** services so you compare VM vs CT operations:

| Role | Suggested on VM | Suggested on LXC |
|------|------------------|------------------|
| Web | nginx or Caddy | nginx in CT |
| DNS | Unbound or dnsmasq | dnsmasq in CT |

**Record which is VM vs LXC** in [VM-vs-LXC-DECISION.md](VM-vs-LXC-DECISION.md).

## Snapshots vs backups (intro)

| Mechanism | Use when | Caution |
|-----------|----------|---------|
| **Snapshot** | Short rollback before a change | On raw devices / certain storage, overhead; not a DR copy off-box |
| **Backup (vzdump)** | Recovery after disk loss | Schedule + test restore (Fase 5) |

**Lab:** Take one **snapshot** of the VM; note time and name. Do **not** rely on it as your only protection.

## Exit criteria

- [ ] One Linux VM running a simple service (reachable from your client).
- [ ] One LXC running a different simple service.
- [ ] Written rationale in [VM-vs-LXC-DECISION.md](VM-vs-LXC-DECISION.md).
