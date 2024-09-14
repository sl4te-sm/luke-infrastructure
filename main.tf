terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.64.0"
    }
  }

  required_version = "~> 1.8.1"
}

provider "proxmox" {
  endpoint = var.proxmoxEndpoint
  username = var.proxmoxUsername
  password = var.proxmoxPassword
  # Temporary as signed certificate is not available yet
  insecure = true

  ssh {
    agent = true
  }
}

resource "proxmox_virtual_environment_download_file" "alma_cloud_image" {
  count        = length(var.proxmoxNodes)
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmoxNodes[count.index]
  url          = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
  file_name    = "almalinux9.img"
}

resource "proxmox_virtual_environment_vm" "k3s_control_node" {
  count     = length(var.proxmoxNodes)
  name      = var.k3sControlNodes[count.index]
  node_name = var.proxmoxNodes[count.index]

  initialization {

    ip_config {
      ipv4 {
        address = var.k3sControlNodeIp[count.index]
        gateway = var.gatewayIp
      }
    }

    dns {
      domain  = var.domainName
      servers = var.dnsServerIp
    }

    user_account {
      username = var.k3sNodeUsername
      keys     = [var.publicKey]
    }
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.alma_cloud_image[count.index].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }

  cpu {
    architecture = "x86_64"
    type         = "x86-64-v2-AES"
    cores        = 2
  }

  memory {
    dedicated = 2048
  }

  operating_system {
    type = "l26"
  }


}

resource "proxmox_virtual_environment_vm" "k3s_worker_node-1" {
  name      = var.k3sWorkerNode1
  node_name = var.proxmoxNodes[0]

  initialization {

    ip_config {
      ipv4 {
        address = var.k3sWorkerNode1Ip
        gateway = var.gatewayIp
      }
    }

    dns {
      domain  = var.domainName
      servers = var.dnsServerIp
    }

    user_account {
      username = var.k3sNodeUsername
      keys     = [var.publicKey]
    }
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.alma_cloud_image[0].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 40
  }

  network_device {
    bridge = "vmbr0"
  }

  cpu {
    architecture = "x86_64"
    type         = "x86-64-v2-AES"
    cores        = 4
  }

  memory {
    dedicated = 10240
  }

  operating_system {
    type = "l26"
  }

}

resource "proxmox_virtual_environment_vm" "k3s_worker_node-2" {
  name      = var.k3sWorkerNode2
  node_name = var.proxmoxNodes[1]

  initialization {

    ip_config {
      ipv4 {
        address = var.k3sWorkerNode2Ip
        gateway = var.gatewayIp
      }
    }

    dns {
      domain  = var.domainName
      servers = var.dnsServerIp
    }

    user_account {
      username = var.k3sNodeUsername
      keys     = [var.publicKey]
    }
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.alma_cloud_image[1].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 40
  }

  network_device {
    bridge = "vmbr0"
  }

  cpu {
    architecture = "x86_64"
    type         = "x86-64-v2-AES"
    cores        = 2
  }

  memory {
    dedicated = 3072
  }

  operating_system {
    type = "l26"
  }

}

resource "proxmox_virtual_environment_vm" "k3s_worker_node-3" {
  name      = var.k3sWorkerNode3
  node_name = var.proxmoxNodes[2]

  initialization {

    ip_config {
      ipv4 {
        address = var.k3sWorkerNode3Ip
        gateway = var.gatewayIp
      }
    }

    dns {
      domain  = var.domainName
      servers = var.dnsServerIp
    }

    user_account {
      username = var.k3sNodeUsername
      keys     = [var.publicKey]
    }
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.alma_cloud_image[2].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 40
  }

  network_device {
    bridge = "vmbr0"
  }

  cpu {
    architecture = "x86_64"
    type         = "x86-64-v2-AES"
    cores        = 4
  }

  memory {
    dedicated = 3072
  }

  operating_system {
    type = "l26"
  }

}

