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
  sensitive   = true
  description = "Proxmox cluster endpoint URL"
}

variable "proxmoxNodes" {
  type        = list(string)
  description = "Proxmox nodes"
}

variable "k3sControlNodes" {
  type        = list(string)
  description = "Kubernetes control nodes"
}
/*
variable "k3sWorkerNodes" {
  type = list(string)
  description = "Kubernetes worker nodes"
}
*/

variable "k3sControlNodeIp" {
  type        = list(string)
  sensitive   = true
  description = "Kubernetes control node IP addresses"
}
/*
variable "k3sWorkerNodeIp" {
  type = list(string)
  sensitive = true
  description = "Kubernetes worker node IP addresses"
}
*/
variable "gatewayIp" {
  type        = string
  sensitive   = true
  description = "Gateway IP address"
}

variable "publicKey" {
  type        = string
  sensitive   = true
  description = "Public authentication key"
}

variable "k3sNodeUsername" {
  type        = string
  sensitive   = true
  description = "Username for kubernetes nodes"
}

variable "domainName" {
  type        = string
  sensitive   = true
  description = "DNS search domain"
}

variable "dnsServerIp" {
  type        = list(string)
  sensitive   = true
  description = "DNS Server IP addresses"
}
