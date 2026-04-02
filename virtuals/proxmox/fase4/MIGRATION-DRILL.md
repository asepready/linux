# Live migration drill (Fase 4 exit)

## Preconditions

- Guest disks on **shared storage** accessible from both nodes, **or** use **migration with local storage** (offline / shared only per PVE capabilities — check docs for your version).
- Cluster healthy: `pvecm status` (or UI).

## Steps

1. Pick a **test VM** (low risk), note **current node**.
2. **Right-click VM → Migrate** (or `qm migrate` on shell).
3. Choose **target node**, **live** if available.
4. Verify VM runs on target; ping/console works.

## Record

| VMID | Source node | Target node | Live or offline | Duration | Notes |
|------|---------------|-------------|-----------------|----------|-------|
| | | | | | |

## Troubleshooting pointers

- Storage not shared → live migration may be unavailable.
- Version mismatch → align PVE versions.
- Network saturation → dedicated migration network in production.

---
