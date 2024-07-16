#!/bin/bash

VERSION="1.7.19"
PLATFORM="amd64"
RUNCVERSION="1.1.13"
CNIVERSION="1.5.1"

# Skip if already installed
if [ -f /etc/containerd/config.toml ]; then
    echo "Containerd already installed"
    exit 0
fi

# Core containerd runtime
if ! [ -f /usr/local/bin/containerd ]; then
    cd /tmp
    wget https://github.com/containerd/containerd/releases/download/v${VERSION}/containerd-${VERSION}-linux-${PLATFORM}.tar.gz
    wget https://github.com/containerd/containerd/releases/download/v${VERSION}/containerd-${VERSION}-linux-${PLATFORM}.tar.gz.sha256sum
    sha256sum -c containerd-${VERSION}-linux-${PLATFORM}.tar.gz.sha256sum
    if [ $? -ne 0 ]; then
        echo "Containerd checksum does not match"
        rm -f containerd-${VERSION}-linux-${PLATFORM}.tar.gz*
        exit 1
    fi
    tar Cxzvf /usr/local /tmp/containerd-${VERSION}-linux-${PLATFORM}.tar.gz
    rm -f containerd-${VERSION}-linux-${PLATFORM}.tar.gz*
fi

# containerd.service
if ! [ -f /etc/systemd/system/containerd.service]; then
    wget -P /etc/systemd/system https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
    systemctl daemon-reload
    systemctl enable --now containerd
fi

# runc binary
if ! [ -f /usr/local/sbin/runc ]; then
    wget https://github.com/opencontainers/runc/releases/download/v${RUNCVERSION}/runc.${PLATFORM}
    install -m 755 runc.${PLATFORM} /usr/local/sbin/runc
fi

# CNI plugins
if ! [ -f /opt/cni/bin/bridge ]; then
    cd /tmp
    wget https://github.com/containernetworking/plugins/releases/download/v${CNIVERSION}/cni-plugins-linux-${PLATFORM}-v${CNIVERSION}.tgz
    wget https://github.com/containernetworking/plugins/releases/download/v${CNIVERSION}/cni-plugins-linux-${PLATFORM}-v${CNIVERSION}.tgz.sha256
    sha256sum -c cni-plugins-linux-${PLATFORM}-v${CNIVERSION}.tgz.sha256
    if [ $? -ne 0 ]; then
        echo "CNI plugins checksum does not match"
        rm -f cni-plugins-linux-${PLATFORM}-v${CNIVERSION}.tgz*
        exit 1
    fi
    mkdir -p /opt/cni/bin
    tar Cxzvf /opt/cni/bin cni-plugins-linux-${PLATFORM}-v${CNIVERSION}.tgz
    rm -f cni-plugins-linux-${PLATFORM}-v${CNIVERSION}.tgz*
fi

mkdir -p /etc/containerd
/usr/local/bin/containerd config default > /etc/containerd/config.toml
