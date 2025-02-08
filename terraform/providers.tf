terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.69.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 6.14.1"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.7.0"
    }
  }

  backend "gcs" {
    bucket = var.stateBucketName
    prefix = "terraform/state"
  }

  required_version = "~> 1.9.0"
}

provider "google" {
  project = var.gcpProject
}

resource "google_storage_bucket" "stateBucket" {
  name     = var.stateBucketName
  location = var.bucketLocation

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

provider "proxmox" {
  endpoint = var.proxmoxEndpoint
  username = var.proxmoxUsername
  password = var.proxmoxPassword
  insecure = false

  ssh {
    agent = true

    node {
      name    = var.proxmoxNodes[0]
      address = "${var.proxmoxNodes[0]}.${var.domainName}"
    }

    node {
      name    = var.proxmoxNodes[1]
      address = "${var.proxmoxNodes[1]}.${var.domainName}"
    }

    node {
      name    = var.proxmoxNodes[2]
      address = "${var.proxmoxNodes[2]}.${var.domainName}"
    }
  }
}
