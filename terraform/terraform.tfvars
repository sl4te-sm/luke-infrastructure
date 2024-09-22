proxmoxNodes = [
  "luke-vmtop-1",
  "luke-vmtop-2",
  "luke-vmtop-3"
]

haproxyContainers = [
  "luke-proxytop-1",
  "luke-proxytop-2"
]

pkiContainer    = "luke-pkitop"
clusterName     = "luke-kubecluster"
domainName      = "luke-domain.com"
dnsServerIp     = ["172.16.10.10"]
gatewayIp       = "172.16.0.1"
proxmoxEndpoint = "https://luke-vmtop-1.luke-domain.com:8006"

controlNodes = [
  "luke-controltop-1",
  "luke-controltop-2",
  "luke-controltop-3"
]

controlNodeIps = [
  "172.16.21.10",
  "172.16.21.11",
  "172.16.21.12"
]

workerNodeIps = [
  "172.16.22.10",
  "172.16.22.11",
  "172.16.22.12"
]

workerNodes = [
  "luke-kubetop-1",
  "luke-kubetop-2",
  "luke-kubetop-3"
]

haproxyContainerIp = [
  "172.16.23.10/16",
  "172.16.23.11/16"
]

pkiContainerIp = "172.16.23.20/16"
publicKey      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN4kOiyt9uHJAeE5CSlDe970yd8tTVherHD2LZ0c1uy"
