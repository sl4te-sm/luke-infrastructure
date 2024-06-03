#!/bin/bash

# Only run this once to setup the root CA

# Prepare the directory
cd /root/ca || exit
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

# Generate the root key and certificate
key="private/ca.key.pem"
cert="certs/ca.cert.pem"
openssl genrsa -aes256 -out $key 4096
chmod 400 private/ca.key.pem
openssl req -new -x509 -sha256 \
    -config openssl.cnf \
    -key $key \
    -days 7300 \
    -extensions v3_ca \
    -out $cert
chmod 444 $cert

openssl x509 -noout -text -in $cert