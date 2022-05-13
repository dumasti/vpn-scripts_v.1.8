#!/bin/bash

if [ $# -lt 1 ]; then
    echo "usage: $0 <comments>"
    echo "      comments     - comments to add user"
    exit 1;
fi
comments=$1
work_dir=`pwd`
echo "How is name/number client? "
read -r
numb=$REPLY
if [[ "$srv" -ge 1 && "$srv" -lt 10 ]]; then
    srv=00${srv}
    elif [[ "$srv" -ge 10 && "$srv" -lt 99 ]]; then
    srv=0${srv}
    elif [[ "$srv" -ge 100 && "$srv" -lt 256 ]]; then
    srv=${srv}
fi
if [[ "$numb" -ge 1 && "$numb" -lt 10 ]]; then
    name=cli${srv}00$numb
    elif [[ "$numb" -ge 10 && "$numb" -lt 99 ]]; then
    name=cli${srv}0$numb
    elif [[ "$numb" -ge 100 && "$numb" -lt 256 ]]; then
    name=cli${srv}$numb
    elif [[ "$numb" -ge 256 ]]; then
    echo "ERROR. Most be between 1-255"
    exit -1
fi
#name=cli$srv$REPLY
cd $work_dir/easy-rsa/
./easyrsa gen-req $name nopass 
printf "yes" | ./easyrsa sign-req client $name 
cp pki/issued/$name.crt $work_dir/keys/
echo "# Openvpn client $name configuration to connect vpn$srv" > $work_dir/files/$name.ovpn
cp pki/private/$name.key $work_dir/keys/
cd $work_dir
source $work_dir/configs-maker.sh $name
#echo "$name ... `date | cut -d ' ' -f 2,3,4` $comments" >> $work_dir/users-base
echo "$name ... `date +%d.%m.%Y' '%H:%M:%S` $comments" >> $work_dir/users-base
echo "Certfile for $name is done. Find him on $work_dir/files/$name"
echo "DONE!"
