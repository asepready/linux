# Ansible — clone VM from template (example)

## Prerequisites

- Python 3 on control node.
- Ansible 2.14+ (`ansible-core` is enough; no extra collections required for `site.yml`).

Optional: `ansible-galaxy collection install -r requirements.yml` if you extend playbooks with `community.general`.

## Configure

1. Copy `inventory.example.yml` to `inventory.yml` (keep out of git if it holds secrets) or pass `--extra-vars`.
2. Create an API token per [../API-TOKEN.md](../API-TOKEN.md); set `proxmox_api_user`, `proxmox_api_token_id`, `proxmox_api_token_secret`.
3. Set `proxmox_node`, `template_vmid`, `new_vmid`, `vm_name`.

**Preferred:** Ansible Vault for secrets.

```bash
ansible-playbook -i inventory.yml site.yml --ask-vault-pass
```

## What `site.yml` does

- Calls `POST /api2/json/nodes/{node}/qemu/{template_vmid}/clone` with `PVEAPIToken` authentication (see Proxmox API docs).

## Notes

- Clone is asynchronous; the response includes a Proxmox task UPID—poll tasks API if you need to wait for completion.
- Optional `clone_target_storage` in inventory adds `storage=` to the clone request for full clones.
