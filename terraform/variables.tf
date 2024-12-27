variable "gcpProject" {
  type        = string
  description = "GCP Project name"
}

variable "stateBucketName" {
  type        = string
  description = "GCP bucket for remote state storage"
}

variable "proxmoxUsername" {
  type        = string
  sensitive   = true
  description = "Proxmox cluster username"
}

variable "proxmoxPassword" {
  type        = string
  sensitive   = true
  description = "Proxmox cluster password"
}

variable "proxmoxEndpoint" {
  type        = string
  description = "Proxmox cluster endpoint URL"
}

variable "bucketLocation" {
  type        = string
  description = "State bucket location"
}

variable "proxmoxNodes" {
  type        = list(string)
  description = "Proxmox nodes"
}

variable "controlNodes" {
  type        = list(string)
  description = "Kubernetes control nodes"
}

variable "controlNodeIps" {
  type        = list(string)
  description = "Kubernetes control node IP addresses"
}

variable "workerNodes" {
  type        = list(string)
  description = "Kubernetes worker nodes"
}

variable "workerNodeIps" {
  type        = list(string)
  description = "Kubernetes worker node IP addresses"
}

variable "gatewayIp" {
  type        = string
  description = "Gateway IP address"
}

variable "publicKey" {
  type        = string
  description = "Public authentication key"
}

variable "domainName" {
  type        = string
  description = "DNS search domain"
}

variable "dnsServerIp" {
  type        = list(string)
  description = "DNS Server IP addresses"
}

variable "lxcContainers" {
  type        = list(string)
  description = "LXC Container Hosts"
}

variable "lxcContainerIp" {
  type        = list(string)
  description = "HAProxy Container IP Addresses"
}

variable "containerPassword" {
  type        = string
  sensitive   = true
  description = "Container password"
}

variable "lxcImageUrl" {
  type        = string
  description = "Download URL for load balancer container image"
}

variable "lxcImageType" {
  type        = string
  description = "Load balancer container type"
  default     = "unmanaged"
}

variable "proxmoxExporterPassword" {
  type        = string
  sensitive   = true
  description = "Password for proxmox exporter user"
}
