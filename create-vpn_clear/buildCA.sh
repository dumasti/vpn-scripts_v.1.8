#!/bin/bash

cp easy-rsa/vars.example easy-rsa/vars
echo 'set_var EASYRSA_REQ_COUNTRY     "RU"
set_var EASYRSA_REQ_PROVINCE    "RU"
set_var EASYRSA_REQ_CITY        "Moskva"
set_var EASYRSA_REQ_ORG         "FirmaNUM_YOUR_VPN"
set_var EASYRSA_REQ_EMAIL       "admin@firmaNUM_YOUR_VPN.com"
set_var EASYRSA_REQ_OU          "Firma0NUM_YOUR_VPN"' >> easy-rsa/vars
echo 'set_var EASYRSA_CA_EXPIRE       7300
set_var EASYRSA_CERT_EXPIRE     1095' >> easy-rsa/vars
cd easy-rsa/
chmod +x easyrsa
./easyrsa init-pki
./easyrsa build-ca nopass

echo "DONE! Start vpn-server-add.sh for create vpn server"
