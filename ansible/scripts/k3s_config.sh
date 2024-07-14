#!/bin/bash

INT_NAME="ens18"
HOST_IP=$(ip addr show $INT_NAME | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
HOST_NAME=$(hostname)
TOKEN=""
AGENT_TOKEN=""

# Exit if required files aren't present
if ! [ -f /home/k3s/.ssl/${HOST_NAME}-chain.cert.pem ] || ! [ -f /home/k3s/.ssl/${HOST_NAME}.key.pem ] || ! [ -f /home/k3s/.ssl/ca.cert.pem ]; then
  echo "Missing certificate files for etcd auth"
  exit 1
elif [ -f /etc/rancher/k3s/k3s.yaml ]; then
  echo "k3s already installed and configured"
  exit 0
fi

# Install the server
curl -sfL https://get.k3s.io | sh -s - server \
  --node-taint CriticalAddonsOnly=true:NoExecute \
  --datastore-endpoint="https://luke-etcdtop-1.luke-domain.com:2379,https://luke-etcdtop-2.luke-domain.com:2379,https://luke-etcdtpo-3.luke-domain.com:2379" \
  --datastore-cafile="/home/k3s/.ssl/ca.cert.pem" \
  --datastore-keyfile="/home/k3s/.ssl/${HOST_NAME}.key.pem" \
  --datastore-certfile="/home/k3s/.ssl/${HOST_NAME}-chain.cert.pem" \
  --token=${TOKEN} \
  --agent-token=${TOKEN} \
  --tls-san="${HOST_NAME}" \
  --tls-san="${HOST_IP}"
