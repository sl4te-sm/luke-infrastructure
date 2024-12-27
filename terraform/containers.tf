#
# Linux Containers
#
resource "proxmox_virtual_environment_container" "lxc_container" {
  count     = length(var.lxcContainers)
  node_name = var.proxmoxNodes[count.index + 1]

  initialization {
    hostname = var.lxcContainers[count.index]

    dns {
      domain  = var.domainName
      servers = var.dnsServerIp
    }

    ip_config {
      ipv4 {
        address = var.lxcContainerIp[count.index]
        gateway = var.gatewayIp
      }
    }

    user_account {
      keys     = [var.publicKey]
      password = var.containerPassword
    }
  }

  disk {
    datastore_id = "local-lvm"
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.lxc_image[count.index].id
    type             = var.lxcImageType
  }

  network_interface {
    name = "veth0"
  }

}
