# Backup job + restore drill (Fase 5 exit)

## Configure backup job

1. **Datacenter → Backup** — **Add** schedule.
2. **Selection:** node or pool; which **VMIDs**.
3. **Storage:** local directory, NFS, PBS (Proxmox Backup Server), etc.
4. **Mode:** snapshot vs suspend vs stop (understand tradeoffs).
5. **Retention:** keep count / keep last N.

**Record**

| Field | Value |
|-------|--------|
| Job ID / name | |
| Schedule | |
| Mode | |
| Target storage | |

## vzdump (CLI reference)

```bash
vzdump 100 --storage <backup-storage-id> --mode snapshot
```

## Restore drill (mandatory)

**Untested backups are fiction.**

1. Pick a **non-production** VM or clone.
2. Run backup; confirm file appears on backup storage.
3. **Delete** test VM (or use new VMID).
4. **Restore** from UI: **Storage → Backups → Restore** (or `qmrestore` / PBR tools per storage type).
5. **Verify:** boot, data present, network works.

### Record

| Date | VMID | Backup time | Restore OK? | Notes |
|------|------|-------------|---------------|-------|
| | | | | |

## Encryption (optional)

- If you enable **encryption**, store keys in a **password manager** — loss of key = loss of data.

---
