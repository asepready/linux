# Example: clone from a template by VM *name* (Telmate/proxmox convention).
# See: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
# Pin provider version in versions.tf; validate arguments against registry docs for your release.

variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL, e.g. https://host:8006/api2/json"
}

variable "proxmox_user" {
  type        = string
  description = "PVE user, e.g. root@pam"
}

variable "proxmox_password" {
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  type = string
}

variable "template_name" {
  type        = string
  description = "Name of the template VM as shown in Proxmox (Telmate clone source)"
}

variable "vm_name" {
  type        = string
  description = "Name for the new VM"
}

variable "vm_id" {
  type        = number
  description = "Explicit VMID for the new guest"
}

variable "full_clone" {
  type    = bool
  default = true
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "from_template" {
  name        = var.vm_name
  target_node = var.proxmox_node
  vmid        = var.vm_id
  clone       = var.template_name
  full_clone  = var.full_clone

  # Add cpu, memory, disk, network blocks per provider docs; clones may need explicit hardware.
  cores   = 2
  memory  = 2048
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
}
