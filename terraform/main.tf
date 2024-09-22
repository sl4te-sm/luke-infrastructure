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
