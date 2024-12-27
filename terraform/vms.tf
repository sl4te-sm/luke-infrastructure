resource "proxmox_virtual_environment_vm" "control_nodes" {
  count       = length(var.controlNodes)
  name        = var.controlNodes[count.index]
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = var.proxmoxNodes[count.index]
  on_boot     = true

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image[count.index].id
    file_format  = "raw"
    interface    = "virtio0"
    size         = 20
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = var.controlNodeIps[count.index]
        gateway = var.gatewayIp
      }
      ipv6 {
        address = "dhcp"
      }
    }
    dns {
      domain  = var.domainName
      servers = [var.gatewayIp]
    }
  }
}

resource "proxmox_virtual_environment_vm" "worker_nodes" {
  depends_on  = [proxmox_virtual_environment_vm.control_nodes[0]]
  count       = length(var.workerNodes)
  name        = var.workerNodes[count.index]
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = var.proxmoxNodes[count.index]
  on_boot     = true
  machine     = "q35"

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 10240
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image[count.index].id
    file_format  = "raw"
    interface    = "virtio0"
    size         = 20
    ssd          = true
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  hostpci {
    device = "hostpci0"
    id     = "0000:00:02.0"
    pcie   = true
    xvga   = true
  }

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = var.workerNodeIps[count.index]
        gateway = var.gatewayIp
      }
      ipv6 {
        address = "dhcp"
      }
    }
    dns {
      domain  = var.domainName
      servers = [var.gatewayIp]
    }
  }
}
