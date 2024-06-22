#!/bin/bash

# Credit to Jamie Nguyen: https://jamielinux.com/docs/openssl-certificate-authority/index.html
# Run this as a crontab to regenerate CRL every 30 days

cd /root/ca/intermediate || exit
openssl ca -gencrl \
    -config openssl.cnf \
    -out crl/intermediate.crl.pem
