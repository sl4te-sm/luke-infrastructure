#!/bin/bash

ETCD_VER=v3.4.33
DOWNLOAD_URL=https://github.com/etcd-io/etcd/releases/download
INSTALL_PATH=/usr/local/bin
TEMP_PATH=/tmp/etcd-download-test

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf $TEMP_PATH && mkdir -p $TEMP_PATH

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C $TEMP_PATH --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
mv ${TEMP_PATH}/* $INSTALL_PATH

${INSTALL_PATH}/etcd --version
${INSTALL_PATH}/etcdctl version
