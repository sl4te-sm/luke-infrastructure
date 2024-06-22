#!/bin/bash

# Credit to Jamie Nguyen: https://jamielinux.com/docs/openssl-certificate-authority/index.html
# Only run this once to setup the root CA

# Prepare the directory
rootDir="/root/ca"
mkdir $rootDir
mv ./root-openssl.cnf "${rootDir}/openssl.cnf"
cd $rootDir || exit 1
mkdir certs crl newcerts private || exit 1
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
