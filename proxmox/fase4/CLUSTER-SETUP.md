# Fase 4 — Cluster creation (checklist)

## Before joining nodes

- [ ] **Same major** Proxmox VE version on all nodes (upgrade stragglers first).
- [ ] **Resolvable hostnames** (DNS or `/etc/hosts` consistently on all nodes).
- [ ] **Corosync network**: dedicated subnet strongly recommended for production; lab may share management LAN.
- [ ] **Firewall**: allow corosync and cluster ports between members (see current Proxmox wiki for version-specific ports).

## Create cluster (first node)

1. **Datacenter → Cluster → Create Cluster**
2. Name cluster `[e.g. lab-cluster]`
3. Note **cluster network** choice (link-0 IP).

## Join second node

1. On second node: **Join Cluster** with **first node IP** and **root password** (one-time).
2. Verify **Datacenter → Cluster** shows both nodes green.

## Quorum (two-node problem)

| Nodes | Issue | Mitigation |
|-------|--------|------------|
| 2 | Split-brain risk if link fails | **qdevice** (witness) or **third node**; understand `expected_votes` |
| 3+ | Majority quorum | Standard HA design |

**Lab goal:** Document whether you use **qdevice** or accept 2-node limitations for learning only.

## HA groups (after storage supports it)

- [ ] Shared storage **or** replication for guests you want HA-migrated.
- [ ] **Datacenter → HA → Add** — group, nodes, **restart policy**.

## Fill in

| Field | Value |
|-------|--------|
| Cluster name | |
| Node A hostname / IP | |
| Node B hostname / IP | |
| Corosync link addresses | |
| qdevice used (y/n) | |
