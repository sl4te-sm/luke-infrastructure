#
# Linux Containers
#
resource "proxmox_virtual_environment_file" "hook_script" {
  count        = length(var.proxmoxNodes)
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmoxNodes[count.index]
  file_mode    = "0700"

  source_raw {
    data      = <<-EOF
      #!/bin/bash

      dnf update -y
      dnf install -y openssh-server
      systemctl start sshd
      EOF
    file_name = "prepare-hook.sh"
  }
}

resource "proxmox_virtual_environment_download_file" "lxc_image" {
  count        = length(var.proxmoxNodes)
  content_type = "vztmpl"
  datastore_id = "local"
  url          = var.lxcImageUrl
  node_name    = var.proxmoxNodes[count.index]
}

resource "proxmox_virtual_environment_container" "lxc_container" {
  count               = length(var.lxcContainers)
  node_name           = var.proxmoxNodes[count.index]
  hook_script_file_id = proxmox_virtual_environment_file.hook_script[count.index].id

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
