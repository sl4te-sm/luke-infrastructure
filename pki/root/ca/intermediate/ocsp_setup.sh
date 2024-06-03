#!/bin/bash

cd /root/ca/intermediate || exit

# Create the OCSP key pair
key="private/ocsp.LUKE-DOMAIN.com.key.pem"
ocspCsr="csr/ocsp.LUKE-DOMAIN.com.key.pem"
openssl genrsa -aes256 -out $key 4096
openssl req -new -sha256 \
    -config openssl.cnf \
    -key $key \
