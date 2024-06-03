#!/bin/bash

# Prepare the directory
mkdir /root/ca
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
openssl req -config openssl.cnf \
    -key $key \
    -new -x509 -days 7300 -sha256 -extensions v3_ca \
    -out $cert
chmod 444 $cert

openssl x509 -noout -text -in $cert