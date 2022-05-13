#!/bin/bash

cd ~/create-vpn/client-configs/easy-rsa/
echo "For which client to revoke the certificate? "
echo `ls pki/issued/ | cut -d '.' -f 1`
read -r
name_crt=$REPLY
printf "yes" | ./easyrsa revoke $name_crt
./easyrsa gen-crl
cp pki/crl.pem ~/create-vpn/client-configs/keys/
echo "DONE!"
