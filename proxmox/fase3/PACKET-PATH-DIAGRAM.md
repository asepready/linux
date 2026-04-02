# Packet path diagram — VLANs on Proxmox (Fase 3)

Use this as a template: replace labels with your **hostnames**, **IPs**, and **switch ports**.

## Logical view

```mermaid
flowchart LR
  subgraph guests [Guests]
    vmA[VM_A_VLAN10]
    vmB[VM_B_VLAN20]
  end
  subgraph pve [Proxmox Host]
    br[vmbr0_vlan_aware]
    tapA[tap_vnet0_tag10]
    tapB[tap_vnet0_tag20]
  end
  subgraph phy [Physical]
    nic[eno1]
    sw[Switch_802.1Q]
  end
  vmA --> tapA
  vmB --> tapB
  tapA --> br
  tapB --> br
  br --> nic
  nic --> sw
```

## Narrative (fill in)

1. **Egress from VM A:** Frame leaves guest with **no tag** (usually); the **tap** device adds **VLAN 10** on the bridge.
2. **On the wire:** One NIC carries **tagged** frames for VLAN 10 and 20 toward the switch.
3. **Switch:** Ports assigned to VLAN 10 or 20 (access) or trunk as designed.
4. **Return path:** Reverse; bridge strips/delivers to correct guest.

## Your drawing

If you prefer Excalidraw or paper, sketch: **Guest → tap → bridge → NIC → switch → router**.

## Exit criteria

- [ ] Diagram saved (this file or exported PNG) with your labels.
- [ ] You can explain **where** tagging happens in your setup.
