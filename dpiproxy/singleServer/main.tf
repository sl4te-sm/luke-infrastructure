terraform {
  required_providers {
    local = {
      source = "hashicorp/terraform-provider-local"
      version = "~> 2.5.1"
    }
    linode = {
      source = "linode/linode"
      version = "~> 2.26.0"
    }
    gcp = {
      source = "hashicorp/google"
      version = "~> 5.41.0"
    }
  }
  required_version = "~> 1.8.1"
  backend "gcs" {
    bucket = var.gcsBucket
    prefix = "terraform/state"
  }
}

provider "gcp" {
  project = var.gcpProject
  region = var.gcpRegion
  zone = var.gcpZone
}

data "terraform_remote_state" "gcs-state" {
  backend = "gcs"
  config = {
    bucket = var.gcsBucket
    prefix = "prod"
  }
}

resource "local_file" "gcs-output" {
  content = data.terraform_remote_state.gcs-state.outputs.greeting
  filename = "${path.module}/outputs.txt"
}

provider "linode" {
  token = var.apiKey
}
