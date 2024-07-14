#!/bin/bash

# Include your etcd DNS entries here
etcdHosts=("www.google.com" "github.com")
# Include the intended subjectName here
subject="/C=US/ST=Illinois/L=Chicago/O=placeholder/emailAddress=placeholder@mail.com"
# Include your username here
user="root"

cd /root/ca || echo "failed to change directory" && exit 1

# Generate cert for each entry
for entry in ${etcdHosts[@]}; do
    # Get the IPv4 address first
    ipAddr=$(host -t A ${entry} | grep -E -o '([0-9]{1,3}\.){1,3}[0-9]{1,3}')
    
    # Generate the certificate
    openssl req -config intermediate/openssl.cnf -extensions etcd_cert \
        -subj "${subject}/CN=${entry}" \
        -addext "subjectAltName = DNS:${entry}, IP:${ipAddr}" \
        -new -outform PEM -out intermediate/certs/${entry}.cert.pem \
        -newkey rsa:2048 -keyform DER -keyout intermediate/private/${entry}.key -noenc \
        -CA intermediate/certs/intermediate.cert.pem -CAkey intermediate/private/intermediate.key.pem \
        || echo "failed to generate cert for entry ${entry}" && exit 1
    chmod 0400 intermediate/private/${entry}.key
    chmod 0444 intermediate/certs/${entry}.cert.pem

    # Create certificate chain
    cat intermediate/certs/${entry}.cert.pem intermediate/certs/intermediate.cert.pem > intermediate/certs/${entry}-chain.cert.pem
    openssl x509 -outform der -in intermediate/certs/${entry}-chain.cert.pem -out intermediate/certs/${entry}.crt
    chmod 0444 intermediate/certs/${entry}.crt

    # Transfer the certificate to the host
    scp certs/ca.cert.pem "${user}@${entry}:/home/${user}"
    scp intermediate/private/${entry}.key "${user}@${entry}:/home/${user}"
    scp intermediate/certs/${entry}.crt "${user}@${entry}:/home/${user}"

    rm -f intermediate/private/${entry}.key
done
