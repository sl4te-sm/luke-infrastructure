#!/bin/bash

# Credit to Jamie Nguyen: https://jamielinux.com/docs/openssl-certificate-authority/index.html

cd /root/ca/intermediate || exit

# Create the OCSP key pair
key="private/ocsp.${domain}.key.pem"
ocspCsr="csr/ocsp.${domain}.key.pem"
openssl genrsa -aes256 -out $key 4096
openssl req -new -sha256 \
    -config openssl.cnf \
    -key $key \
    -out $ocspCsr

