# NIC bonding — lab notes (Fase 3)

## Modes (short)

| Mode | Linux | Typical use |
|------|--------|-------------|
| Active-backup | `active-backup` | One NIC up; failover to second. **No** special switch config beyond normal access ports. |
| LACP | `802.3ad` | Aggregate bandwidth + redundancy; **requires** LACP on switch (LAG). |

## Lab checklist

- [ ] Document **bond name** (e.g. `bond0`) and **slaves** (`eno1`, `eno2`).
- [ ] If using **LACP**: switch port-channel **mode active** (terminology varies by vendor).
- [ ] Attach **bridge** to **bond** (`bridge-ports bond0`) not to individual NICs.
- [ ] Failover test: unplug one cable; ping should recover (active-backup) or LACP should maintain (if configured).

## Example fragment (illustrative only)

```text
auto bond0
iface bond0 inet manual
    bond-slaves eno1 eno2
    bond-miimon 100
    bond-mode active-backup
    bond-primary eno1

auto vmbr0
iface vmbr0 inet static
    address 192.168.1.10/24
    gateway 192.168.1.1
    bridge-ports bond0
    bridge-stp off
    bridge-fd 0
```

**Validate** with your PVE version docs — prefer **Node → Network → Create → Linux Bond** in UI when possible.

## Your bond documentation

| Field | Value |
|-------|--------|
| Mode | |
| Slaves | |
| Switch config (vendor notes) | |
| Test result | |
