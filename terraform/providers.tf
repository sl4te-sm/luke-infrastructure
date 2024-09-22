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

    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.5.0"
    }
  }

  backend "gcs" {
    bucket = var.stateBucketName
    prefix = "terraform/state"
  }

  required_version = "~> 1.8.1"
}
