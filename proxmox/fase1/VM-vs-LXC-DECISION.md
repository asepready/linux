# VM vs LXC — decision log (fill in)

## Services in this lab

| Workload | VMID | Type (VM/LXC) | Service | Why this type |
|----------|------|---------------|---------|----------------|
| Example | 100 | VM | … | Full kernel needed / Windows / PCI passthrough |
| Example | 200 | LXC | … | Linux-only, low overhead, fast clone |

## When to choose **VM (QEMU)**

- Non-Linux guests (Windows, BSD with specific needs).
- Different kernel than the host; kernel tuning isolation.
- Hardware passthrough (GPU, USB, etc.).
- Stronger isolation boundary for untrusted workloads (still not a substitute for full security design).

## When to choose **LXC**

- Linux application stacks with the same kernel ABI expectations.
- Higher density and faster provisioning when templates fit.
- Lower overhead for equivalent workloads (typical case).

## Your one-paragraph summary

*(Write 3–5 sentences: what you deployed and when you would pick VM vs LXC next time.)*

---
