stateBucketName = "luke-infrastructure-state"
gcpProject      = "neural-orbit-361620"

proxmoxNodes = [
  "luke-vmtop-1",
  "luke-vmtop-2",
  "luke-vmtop-3"
]

lxcContainers = [
  "luke-proxytop-1",
  "luke-proxytop-2"
]

domainName      = "luke-domain.com"
dnsServerIp     = ["172.16.20.254"]
gatewayIp       = "172.16.20.254"
proxmoxEndpoint = "https://proxmox.services.luke-domain.com"
bucketLocation  = "us-central1"
controlNodes = [
  "luke-controltop-1",
  "luke-controltop-2",
  "luke-controltop-3"
]

controlNodeIps = [
  "172.16.20.20/24",
  "172.16.20.21/24",
  "172.16.20.22/24"
]

workerNodeIps = [
  "172.16.20.30/24",
  "172.16.20.31/24",
  "172.16.20.32/24"
]

workerNodes = [
  "luke-kubetop-1",
  "luke-kubetop-2",
  "luke-kubetop-3"
]

lxcContainerIp = [
  "172.16.20.40/24",
  "172.16.20.41/24"
]

lxcImageUrl  = "http://download.proxmox.com/images/system/alpine-3.21-default_20241217_amd64.tar.xz"
lxcImageType = "alpine"
publicKey    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN4kOiyt9uHJAeE5CSlDe970yd8tTVherHD2LZ0c1uy"
