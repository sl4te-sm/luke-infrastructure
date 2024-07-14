#!/bin/bash

INT_NAME="ens18"
HOST_IP=$(ip addr show $INT_NAME | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
HOST_NAME=$(hostname -s)
DATA_DIR=/var/lib/etcd

# Verify that certificate files are present first
if ! [ -f ${DATA_DIR}/.ssl/ca.crt ]; then
    echo "Missing trusted CA cert"
    exit 1
elif ! [ -f ${DATA_DIR}/.ssl/${HOST_NAME}.luke-domain.com.crt ]; then
    echo "Missing host certificate"
    exit 1
elif ! [ -f ${DATA_DIR}/.ssl/${HOST_NAME}.luke-domain.com.key ]; then
    echo "Missing host private key"
    exit 1
fi

# Create the systemd service
cat <<EOF | tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd service
Documentation=https://github.com/etcd-io/etcd

[Service]
Type=notify
User=etcd
ExecStart=/usr/local/bin/etcd \\
    --name ${HOST_NAME} \\
    --data-dir=${DATA_DIR} \\
    --initial-advertise-peer-urls https://${HOST_IP}:2380 \\
    --listen-peer-urls https://${HOST_IP}:2380 \\
    --listen-client-urls https://${HOST_IP}:2379,https://127.0.0.1:2379 \\
    --advertise-client-urls https://${HOST_IP}:2379 \\
    --initial-cluster-token luke-etcdcluster \\
    --initial-cluster luke-etcdtop-1=https://luke-etcdtop-1.luke-domain.com:2380,luke-etcdtop-2=https://luke-etcdtop-2.luke-domain.com:2380,luke-etcdtop-3=https://luke-etcdtop-3.luke-domain.com:2380 \\
    --initial-cluster-state new \\
    --client-cert-auth --trusted-ca-file=${DATA_DIR}/.ssl/ca.crt \\
    --cert-file=${DATA_DIR}/.ssl/${HOST_NAME}.luke-domain.com.crt \\
    --key-file=${DATA_DIR}/.ssl/${HOST_NAME}.luke-domain.com.key \\
    --peer-client-cert-auth --peer-trusted-ca-file=${DATA_DIR}/.ssl/ca.crt \\
    --peer-cert-file=${DATA_DIR}/.ssl/${HOST_NAME}.luke-domain.com.crt \\
    --peer-key-file=${DATA_DIR}/.ssl/${HOST_NAME}.luke-domain.com.key \

[Install]
WantedBy=multi-user.target
EOF
