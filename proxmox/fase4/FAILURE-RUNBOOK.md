# Failure runbook — cluster (Fase 4 exit)

## Scenario A: One node dead (hardware / power)

### Symptoms

- Node missing in UI; `pvecm status` shows offline member.
- VMs on that node may be **stopped** unless HA restarted them elsewhere (needs shared/replicated storage + HA).

### Actions

1. **Confirm** failure (IPMI, ping, serial console).
2. **Do not** blindly power-cycle surviving node if unsure about quorum (understand your design).
3. **Document** which guests were on failed node (from backups or HA history).
4. **Recover:** replace hardware, reinstall **same PVE major**, **join** existing cluster if cluster still has quorum — follow Proxmox **replace failed node** documentation for your version.
5. **Restore** guests from backup if disks are lost (Fase 5).

### Record your lab drill

| Date | What you simulated | Result |
|------|-------------------|--------|

---

## Scenario B: Split-brain suspicion

### Symptoms

- Two parts of cluster both think they are primary; conflicting state.
- Intermittent corosync errors; fence-like behavior.

### Actions

1. **Stop** creating new guests until resolved.
2. Gather **corosync** logs on all nodes (`journalctl`, `/var/log/syslog`).
3. Follow **official** Proxmox guidance for **quorum** recovery (often involves ensuring one side has majority or using `pvecm` recovery procedures — **version-specific**).
4. **Never** guess: wrong `pvecm` commands can destroy cluster state.

### Prevention

- Odd number of votes (3 nodes or 2 + qdevice).
- Reliable **cluster network** (dedicated link).

---

## Scenario C: Planned maintenance — evacuate node

1. **Migrate** or **shutdown** guests to other nodes (or accept downtime).
2. **Drain:** confirm no HA services pinned only to this node incorrectly.
3. **Maintenance mode** per your org (optional `crm`/`ha` constraints — check version).
4. **Update/reboot** node; verify rejoin cluster.

---

## Your notes

*(Links to internal tickets, switch port numbers, IPMI URLs — keep secrets out of git.)*
