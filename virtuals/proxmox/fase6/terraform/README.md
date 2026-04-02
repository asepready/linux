# Terraform — Proxmox (example skeleton)

## Provider

This repo uses the community [Telmate/proxmox](https://registry.terraform.io/providers/Telmate/proxmox) provider. Pin a version that matches your Proxmox major release.

## Setup

1. Install [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.0.
2. Copy `terraform.tfvars.example` to `terraform.tfvars` (gitignored) and fill secrets.
3. `terraform init`

## Apply

```bash
cd fase6/terraform
terraform plan
terraform apply
```

`main.tf` includes a **clone** resource pattern; adjust `clone_id`, `target_node`, and storage to your lab.

## Security

- Never commit `terraform.tfstate` if it contains secrets; use remote backend with locking in real use.
