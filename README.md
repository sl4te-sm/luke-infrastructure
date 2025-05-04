# luke-infrastructure

Repository containing the entire state of my homelab

## Resources overview

My homelab is as follows:

- 3x physical machines
    - each is running [Proxmox VE](https://proxmox.com/en/)
    - 16GB memory on each
- 6-node Kubernetes cluster
    - 3x control node, 3x worker node
    - all nodes are running [Talos Linux](https://www.talos.dev/)
- 2x reverse proxy linux containers
    - uses HAProxy+Keepalived for redundant proxies access to the cluster apps

All virtual machines and linux containers are deployed via Terraform
