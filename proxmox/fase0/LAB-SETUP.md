# Fase 0 — Persiapan & environment

## Hardware sketch

| Concern | Lab guidance |
|---------|----------------|
| RAM | Nested PVE: ≥ 8 GiB for the PVE VM; more if you run several guests. |
| CPU | Enable VT-x/AMD-V on bare metal; enable nested virt if PVE runs inside a VM. |
| Disk | SSD strongly recommended for responsiveness. |
| Network | One NIC is enough for Fase 0–3; second NIC helps for dedicated cluster/storage later. |

## Web UI tour checklist

- [ ] **Datacenter** → **Summary** — node health.
- [ ] **Node** → **Shell** — host console.
- [ ] **Node** → **Network** — bridges (`vmbr0`).
- [ ] **Node** → **Storage** — local storage types.
- [ ] **Node** → **Updates** — pending packages.
- [ ] Create a folder under **Datacenter** if you use resource pools (optional).

## Conceptual: config you care about

- Host config lives under `/etc/pve` (cluster-aware when joined).
- Guest definitions: `/etc/pve/qemu-server/<vmid>.conf`, `/etc/pve/lxc/<vmid>.conf`.

## Exit criteria (from plan)

1. Reinstall runbook completed once: [RUNBOOK-reinstall.md](RUNBOOK-reinstall.md).
2. Access documented: [ACCESS.md](ACCESS.md).
