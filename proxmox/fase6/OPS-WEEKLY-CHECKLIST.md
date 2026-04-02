# Weekly ops checklist (Fase 6 exit)

Run after updates window or every 7 days in lab; daily in production.

## Cluster and nodes

- [ ] **Datacenter → Summary** — all nodes online (if clustered).
- [ ] `pvecm status` — quorum OK; no unexpected offline members.
- [ ] **Node → Updates** — pending security updates reviewed.

## Storage

- [ ] No storage at **100%**; ZFS pools healthy (`zpool status` if applicable).
- [ ] Ceph: **HEALTH_OK** if using Ceph (UI or `ceph status`).

## Backups

- [ ] Last backup job **succeeded** (no failed tasks).
- [ ] Retention still matches policy; disk on backup target not full.

## Guests

- [ ] No VM in **unknown** or **locked** state without a ticket.
- [ ] HA resources (if any) in expected state.

## Security

- [ ] No unexpected **API token** or user changes since last review.
- [ ] TLS cert expiry (ACME or manual) — renew before expiry.

## Automation

- [ ] Git repo for IaC (Ansible/Terraform) matches applied state or drift documented.

## Notes (date / initials)

| Week ending | Operator | Exceptions |
|-------------|----------|------------|
| | | |

---
