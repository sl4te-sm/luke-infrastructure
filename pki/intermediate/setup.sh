#!/bin/bash

# Initialize the path
mkdir /root/ca/intermediate
cd /root/ca/intermediate || exit
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

# Generate the intermediate key and certificate signing request
key="private/intermediate.key.pem"
cert="csr/intermediate.csr.pem"
openssl genrsa -aes256 -out $key 4096
chmod 400 $key
openssl req -new -sha256 \
    -config openssl.cnf \
    -key $key \
    -out $cert