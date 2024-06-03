#!/bin/bash

# Create the intermediate certificate
cd /root/ca || exit
rootCert="certs/ca.cert.pem"
intermediateCert="intermediate/certs/intermediate.cert.pem"
openssl ca -notext \
    -config openssl.cnf \
    -extensions v3_intermediate_ca \
    -days 3650 \
    -md sha256 \
    -in intermediate/csr/intermediate.csr.pem \
    -out $intermediateCert
chmod 444 $intermediateCert
openssl verify -CAfile $rootCert $intermediateCert

# Create the certificate chain file
chain="intermediate/certs/ca-chain.cert.pem"
cat $intermediateCert $rootCert > $chain
chmod 444 $chain