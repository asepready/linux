# Where VM disks live (Fase 5 exit)

Fill this diagram’s labels for **your** lab.

```mermaid
flowchart TB
  subgraph guests [Guests]
    vm1[VM_100]
    vm2[VM_101]
  end
  subgraph pve [Proxmox]
    ds[Storage_IDs_in_PVE]
  end
  subgraph backends [Backends]
    zfs[ZFS_pool_or_dataset]
    nfs[NFS_export]
    ceph[Ceph_pool]
  end
  vm1 --> ds
  vm2 --> ds
  ds --> zfs
  ds --> nfs
  ds --> ceph
```

## Table (your environment)

| VMID / CTID | Storage ID in PVE | Backend type | Path or pool | Backup included in job? |
|-------------|-------------------|--------------|--------------|-------------------------|
| | | | | |

## Narrative

*(One paragraph: primary disk location, backup target, and what happens if the node vanishes.)*

---
