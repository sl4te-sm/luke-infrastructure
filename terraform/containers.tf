#
# Linux Containers
#

resource "proxmox_virtual_environment_download_file" "alpine_lxc_image" {
  count        = length(var.proxmoxNodes)
  content_type = "vztmpl"
  datastore_id = "local"
  url          = "http://download.proxmox.com/images/system/alpine-3.18-default_20230607_amd64.tar.xz"
  node_name    = var.proxmoxNodes[count.index]
}

resource "proxmox_virtual_environment_container" "pki_container" {
  node_name = var.proxmoxNodes[0]

  initialization {
    hostname = var.pkiContainer

    dns {
      domain  = var.domainName
      servers = var.dnsServerIp
    }

    ip_config {
      ipv4 {
        address = var.pkiContainerIp
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
    template_file_id = proxmox_virtual_environment_download_file.alpine_lxc_image[0].id
    type             = "alpine"
  }

  network_interface {
    name = "veth0"
  }
}

resource "proxmox_virtual_environment_container" "haproxy_container" {
  count     = length(var.proxmoxNodes) - 1
  node_name = var.proxmoxNodes[count.index + 1]

  initialization {
    hostname = var.haproxyContainers[count.index]

    dns {
      domain  = var.domainName
      servers = var.dnsServerIp
    }

    ip_config {
      ipv4 {
        address = var.haproxyContainerIp[count.index]
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
    template_file_id = proxmox_virtual_environment_download_file.alpine_lxc_image[count.index + 1].id
    type             = "alpine"
  }

  network_interface {
    name = "veth0"
  }
}
