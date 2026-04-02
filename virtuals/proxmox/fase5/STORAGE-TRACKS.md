# Fase 5 — Storage tracks (pick depth for your lab)

## Track A: Local ZFS

**Learn:** pools, datasets, compression, snapshots.

| Step | Action |
|------|--------|
| 1 | Identify disks for pool (mirror vs single-disk lab). |
| 2 | Create pool via **Node → Disks → ZFS** or `zpool create` (destructive). |
| 3 | Add **ZFS** storage in **Datacenter → Storage** pointing at dataset. |
| 4 | Set **compression** (e.g. `lz4`) for lab; note RAM implications for dedup (usually off in lab). |
| 5 | Practice **zfs snapshot** at CLI; map to PVE snapshots where applicable. |

**Record:** pool name `___`, layout `___`, dataset for VMs `___`.

## Track B: NFS / iSCSI

**Learn:** shared storage for migration/HA.

| Step | Action |
|------|--------|
| 1 | Deploy NFS or iSCSI target (appliance or Linux). |
| 2 | **Datacenter → Storage → Add** — NFS or iSCSI; run **content** scan. |
| 3 | Create test VM disk on shared storage; verify both nodes see it (Fase 4). |

## Track C: Ceph (overview lab)

**Learn:** MON / OSD / manager; crush rules; pools.

| Step | Action |
|------|--------|
| 1 | Read architecture section in Proxmox **Ceph** chapter for your version. |
| 2 | Lab: minimum OSD count vs redundancy (often **not** tiny clusters). |
| 3 | Install **ceph** meta-package on nodes per wizard; create **pool** for VM disks. |

**Record:** pool name `___`, replication/size `___`.

---

Choose **at least one** track deeply; skim others for interviews/ops breadth.
