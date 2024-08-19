variable apiKey {
  type = string
  sensitive = true
  description = "Linode API key"
}

variable gcpProject {
  type = string
  description = "Google Cloud Project name"
}

variable gcpRegion {
  type = string
  description = "Google Cloud region"
}

variable "gcpZone" {
  type = string
  description = "Google Cloud availability zone"
}

variable gcsBucket {
  type = string
  description = "Google Cloud Storage Bucket name"
}
