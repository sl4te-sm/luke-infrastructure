locals {
  talos = {
    version = "v1.9.0"
  }
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
  count        = length(var.proxmoxNodes)
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmoxNodes[count.index]

  file_name               = "talos-${local.talos.version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/787b79bb847a07ebb9ae37396d015617266b1cef861107eaec85968ad7b40618/${local.talos.version}/nocloud-amd64.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}

resource "proxmox_virtual_environment_download_file" "lxc_image" {
  count        = length(var.lxcContainers)
  content_type = "vztmpl"
  datastore_id = "local"
  url          = var.lxcImageUrl
  node_name    = var.proxmoxNodes[count.index + 1]
}
