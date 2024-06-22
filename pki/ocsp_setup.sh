#!/bin/bash

# Credit to Jamie Nguyen: https://jamielinux.com/docs/openssl-certificate-authority/index.html

cd /root/ca/intermediate || exit

# Create the OCSP key pair
key="private/ocsp.LUKE-DOMAIN.com.key.pem"
ocspCsr="csr/ocsp.LUKE-DOMAIN.com.key.pem"
openssl genrsa -aes256 -out $key 4096
openssl req -new -sha256 \
    -config openssl.cnf \
    -key $key \
    -out $ocspCsr

