variable "gcpProject" {
  type        = string
  sensitive   = true
  description = "GCP Project name"
}

variable "stateBucketName" {
  type        = string
  sensitive   = true
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
  sensitive   = true
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

variable "haproxyContainers" {
  type        = list(string)
  description = "HAProxy Container Hosts"
}

variable "haproxyContainerIp" {
  type        = list(string)
  description = "HAProxy Container IP Addresses"
}

variable "pkiContainer" {
  type        = string
  description = "OpenSSL PKI Container Host"
}

variable "pkiContainerIp" {
  type        = string
  description = "OpenSSL PKI Container IP Address"
}

variable "containerPassword" {
  type        = string
  sensitive   = true
  description = "Container password"
}

variable "clusterName" {
  type        = string
  description = "K8s cluster name"
}
