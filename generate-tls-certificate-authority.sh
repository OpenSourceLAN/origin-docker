#!/bin/bash

mkdir -p ca/epic
cd ca

openssl genrsa -out rootca.key 2048

# Just press enter to all of the questions to accept defaults
openssl req -batch -x509 -new -nodes -key rootca.key -sha256 -days 10000 -out rootca.pem

# Generate your server private key
openssl genrsa -out epic/client.key 2048

# Server CSR
openssl req -new -key epic/client.key -out epic/client.csr -subj "/C=US/ST=CA/O=Acme, Inc./CN=download.epicgames.com" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:download1.epicgames.com,DNS:download2.epicgames.com,DNS:download3.epicgames.com,DNS:download4.epicgames.com,DNS:cdn1.epicgames.com,DNS:cdn2.epicgames.com,DNS:cdn1.unrealengine.com,DNS:cdn2.unrealengine.com,DNS:cdn3.unrealengine.com,DNS:static-assets-prod.epicgames.com,DNS:epicgames-download1.akamaized.net"))

# Sign the server CSR
openssl x509 -req -in epic/client.csr -CA rootca.pem  -CAkey rootca.key  -CAcreateserial -out epic/client.pem -days 10000 -sha256

# Export your CA for use in windows

echo "!!!"
echo "OpenSSL is about to ask you for a password. The certificate authority file you will import"
echo "in to Windows must have a password on it. This doesn't need to be secure, so even 'password'"
echo "is fine."
echo "Press enter to continue and *then* enter a password when prompted."
echo "!!!"
read 
openssl pkcs12 -export -in rootca.pem -out rootca.p12 -nokeys

echo "All done!"
echo "You now have a folder 'ca/' which contains your certificate authority and keys."
echo "Mount this at /etc/nginx/ssl/ in the origin-docker container to use them."
echo "And then copy to then install rootca.p12 on all of your Windows PCs that need"
echo "to trust the certificate authority to use the cache"
