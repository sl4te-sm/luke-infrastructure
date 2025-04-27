locals {

  certs = [
    file("${path.module}/certs/luke-vmtop-1.crt"),
    file("${path.module}/certs/luke-vmtop-2.crt"),
    file("${path.module}/certs/luke-vmtop-3.crt")
  ]

  ca = file("${path.module}/certs/luke-domain.crt")

}

data "google_secret_manager_secret_version" "proxmox-key" {
  count    = length(var.proxmoxNodes)
  provider = google
  secret   = "luke-vmtop-${count.index + 1}-key"
  version  = "2"
}

resource "proxmox_virtual_environment_certificate" "ssl_cert" {
  count             = length(var.proxmoxNodes)
  node_name         = var.proxmoxNodes[count.index]
  certificate       = local.certs[count.index]
  private_key       = data.google_secret_manager_secret_version.proxmox-key[count.index].secret_data
  certificate_chain = local.ca
}

resource "proxmox_virtual_environment_apt_standard_repository" "no-subscription" {
  count  = length(var.proxmoxNodes)
  handle = "no-subscription"
  node   = var.proxmoxNodes[count.index]
}

resource "proxmox_virtual_environment_apt_standard_repository" "enterprise" {
  count  = length(var.proxmoxNodes)
  handle = "enterprise"
  node   = var.proxmoxNodes[count.index]
}

resource "proxmox_virtual_environment_apt_repository" "no-subscription" {
  count     = length(var.proxmoxNodes)
  enabled   = true
  file_path = proxmox_virtual_environment_apt_standard_repository.no-subscription[count.index].file_path
  index     = proxmox_virtual_environment_apt_standard_repository.no-subscription[count.index].index
  node      = var.proxmoxNodes[count.index]
}

resource "proxmox_virtual_environment_apt_repository" "enteprise" {
  count     = length(var.proxmoxNodes)
  enabled   = false
  file_path = proxmox_virtual_environment_apt_standard_repository.enterprise[count.index].file_path
  index     = proxmox_virtual_environment_apt_standard_repository.enterprise[count.index].index
  node      = var.proxmoxNodes[count.index]
}

resource "proxmox_virtual_environment_group" "read-only" {
  comment  = "Read-only access"
  group_id = "ReadOnly"

  acl {
    path      = "/"
    role_id   = "PVEAuditor"
    propagate = true
  }
}

resource "proxmox_virtual_environment_user" "proxmox-exporter" {
  user_id  = "proxmox-exporter@pve"
  password = var.proxmoxExporterPassword
  enabled  = true
  groups   = [proxmox_virtual_environment_group.read-only.group_id]
}

resource "proxmox_virtual_environment_user_token" "proxmox-exporter-token" {
  token_name            = "proxmox-exporter"
  user_id               = proxmox_virtual_environment_user.proxmox-exporter.user_id
  privileges_separation = false
}
