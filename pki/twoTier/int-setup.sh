#!/bin/bash

# Initialize the path
rootPath="/root/ca/intermediate"
mkdir $rootPath
mv ./int-openssl.cnf "${rootPath}/openssl.cnf"
cd /root/ca/intermediate || exit 1
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
