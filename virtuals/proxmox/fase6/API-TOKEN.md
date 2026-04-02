# API token setup (Fase 6)

## Create token in Proxmox UI

1. **Datacenter → Permissions → Users** — use a **dedicated** automation user (create Linux user + PVE user if needed).
2. **Permissions:** grant minimal role (e.g. `PVEVMAdmin` on a pool, or VM-only paths).
3. **API Tokens → Add** — note **Token ID** and **Secret** once; **secret is shown only at creation**.

## Test with `pvesh` (on a trusted host)

```bash
export PM_USER='automation@pam!mytoken'
export PM_PASS='<secret>'
pvesh get /nodes/$(hostname -s)/status --output-format json
```

Or use ticket auth per Proxmox API docs.

## curl example (replace values)

```bash
curl -k -d "username=automation@pam&password=<secret>" \
  https://pve.example:8006/api2/json/access/ticket
```

Use returned `ticket` + `CSRFPreventionToken` for subsequent calls (see official API documentation).

## Rules

- **Rotate** tokens when people leave or after leaks.
- **Never** commit tokens; use `secrets.env` (gitignored) or Ansible Vault.

See [ansible/README.md](ansible/README.md) and [terraform/README.md](terraform/README.md).
