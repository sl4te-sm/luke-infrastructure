variable proxmoxUsername {
  type = string
  sensitive = true
  description = "Proxmox cluster username"
}

variable proxmoxPassword {
  type = string
  sensitive = true
  description = "Proxmox cluster password"
}

variable proxmoxEndpoint {
  type = string
  description = "Proxmox cluster endpoint URL"
}
