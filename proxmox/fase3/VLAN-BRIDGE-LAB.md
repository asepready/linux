# Fase 3 — VLAN-aware bridge lab

## Prerequisites

- Physical switch (or hypervisor) that supports **802.1Q tagging** on the uplink to PVE, **or** a lab with only software-defined VLANs on one host.
- **Backup** `/etc/network/interfaces` (or Netplan if used) before editing.

## Concept

- **vmbr0** untagged = “native” LAN (often management).
- **VLAN-aware bridge**: one bridge carries multiple VLANs; each VM gets a **VLAN tag** per virtual NIC.

## Lab target (exit criteria)

- [ ] **Two VLANs** (e.g. `10` and `20`) on the same bridge.
- [ ] **Two guests** (VM or LXC), one on VLAN 10, one on VLAN 20.
- [ ] **No cross-talk** without a router (expected); verify with `ping` / `tcpdump`.

## UI path (typical)

1. **Node → Network → Create → Linux Bridge**.
2. Enable **VLAN aware** on the bridge attached to your physical NIC.
3. On each guest NIC, set **VLAN tag** to `10` or `20`.

## Example `/etc/network/interfaces` fragment (adapt to your node)

**Warning:** Wrong network config can lock you out. Keep console/IPMI access.

```text
auto eno1
iface eno1 inet manual

auto vmbr0
iface vmbr0 inet static
    address 192.168.1.10/24
    gateway 192.168.1.1
    bridge-ports eno1
    bridge-stp off
    bridge-fd 0
    bridge-vlan-aware yes
    bridge-vids 2-4094
```

Guest VLANs are configured on **tap** side in UI or VM config, not always as separate `interfaces` stanzas for each VLAN (PVE attaches tags per guest).

## Packet path

See [PACKET-PATH-DIAGRAM.md](PACKET-PATH-DIAGRAM.md).

## Fill in your lab values

| VLAN ID | Subnet | Purpose | Guest VMID |
|---------|--------|---------|------------|
| 10 | | | |
| 20 | | | |
