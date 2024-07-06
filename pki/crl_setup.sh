#!/bin/bash

cd /root/ca/intermediate || exit
openssl ca -gencrl \
    -config openssl.cnf \
    -out crl/intermediate.crl.pem
