terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.64.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 6.3.0"
    }
  }

  backend "gcs" {
    bucket = var.stateBucketName
    prefix = "terraform/state"
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

provider "google" {
  project = var.gcpProject
}

resource "google_storage_bucket" "stateBucket" {
  name     = var.stateBucketName
  location = "us-central1"

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}


#
# Virtual machines configuration
#

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

resource "proxmox_virtual_environment_vm" "k3s_worker_node" {
  count     = length(var.proxmoxNodes)
  name      = var.k3sWorkerNodes[count.index]
  node_name = var.proxmoxNodes[count.index]

  initialization {

    ip_config {
      ipv4 {
        address = var.k3sWorkerNodeIp[count.index]
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
    size         = 40
  }

  network_device {
    bridge = "vmbr0"
  }

  cpu {
    architecture = "x86_64"
    type         = "x86-64-v2-AES"
    cores        = 4
    numa         = true
  }

  memory {
    dedicated = 10240
  }

  operating_system {
    type = "l26"
  }

}
/*
#
# Linux Containers
#

resource "proxmox_virtual_environment_file" "proxy_init_script" {
  count        = length(var.proxmoxNodes) - 1
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmoxNodes[count.index + 1]

  source_file {
    path = var.lxcInitScript[count.index]
  }
}

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
  count               = length(var.proxmoxNodes) - 1
  node_name           = var.proxmoxNodes[count.index + 1]
  hook_script_file_id = proxmox_virtual_environment_file.proxy_init_script[count.index].id

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
*/
