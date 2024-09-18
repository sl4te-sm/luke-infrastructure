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

variable "k3sControlNodeIp" {
  type        = list(string)
  sensitive   = true
  description = "Kubernetes control node IP addresses"
}

variable "k3sWorkerNode1" {
  type        = string
  description = "Kubernetes worker node on host 1"
}

variable "k3sWorkerNode2" {
  type        = string
  description = "Kubernetes worker node on host 2"
}

variable "k3sWorkerNode3" {
  type        = string
  description = "Kubernetes worker node on host 3"
}

variable "k3sWorkerNode1Ip" {
  type        = string
  sensitive   = true
  description = "Kubernetes worker node on host 1 IP address"
}

variable "k3sWorkerNode2Ip" {
  type        = string
  sensitive   = true
  description = "Kubernetes worker node on host 2 IP address"
}

variable "k3sWorkerNode3Ip" {
  type        = string
  sensitive   = true
  description = "Kubernetes worker node on host 3 IP address"
}

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

variable "haproxyContainers" {
  type        = list(string)
  description = "HAProxy Container Hosts"
}

variable "haproxyContainerIp" {
  type        = list(string)
  sensitive   = true
  description = "HAProxy Container IP Addresses"
}

variable "proxyPassword" {
  type        = string
  sensitive   = true
  description = "HAProxy container password"
}
