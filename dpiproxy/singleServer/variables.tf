# Google Cloud variables
variable gcpProject {
  type = string
  description = "Google Cloud Project name"
  default = "dpiproxy"
}

variable gcpRegion {
  type = string
  description = "Google Cloud region"
  default = "us-central1"
}

variable "gcpZone" {
  type = string
  description = "Google Cloud availability zone"
  default = "us-central1-a"
}

variable gcsBucket {
  type = string
  description = "Google Cloud Storage Bucket name"
  default = "dpiproxy-state-bucket"
}

# Linode variables
variable apiKey {
  type = string
  sensitive = true
  description = "Linode API key"
}

variable linodeName {
  type = string
  description = "Linode instance name"
  default = "dpiproxy"
}

variable linodeRegion {
  type = string
  description = "Linode instance region"
  default = "us-ord"
}

variable linodeImage {
  type = string
  description = "Linode instance image"
  default = "linode/almalinux9"
}

variable linodeType {
  type = string
  description = "Linode instance type"
  default = "g6-nanode-1"
}

variable linodeSSHKeys {
  type = list(string)
  description = "Linode instance SSH keys"
  sensitive = true
}

variable linodePassword {
  type = string
  description = "Linode instance root password"
  sensitive = true
}
