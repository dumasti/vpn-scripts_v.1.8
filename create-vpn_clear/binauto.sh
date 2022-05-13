#!/bin/bash

rotate='/var/log/openvpn.vpn*.log {
        weekly
        missingok
        copytruncate
        rotate 10
        compress
        delaycompress
}'

if [ ! -e /etc/logrotate.d/openvpn ]; then
        echo "$rotate" > /etc/logrotate.d/openvpn
fi
