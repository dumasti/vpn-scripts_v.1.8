#!/bin/bash

work_dir=`pwd`
echo "How is name server? "
read -r
name=$REPLY
mkdir -p srv/$name/ccd
mkdir srv/$name/bin
mkdir srv/$name/keys
cp auto.sh srv/$name/ccd/
cd easy-rsa/
./easyrsa gen-req $name nopass 
./easyrsa gen-dh
sudo openvpn --genkey --secret ta.key
printf "yes" | ./easyrsa sign-req server $name 
cp pki/issued/$name.crt $work_dir/srv/$name/keys/
cp pki/private/$name.key $work_dir/srv/$name/keys/
cp pki/ca.crt $work_dir/srv/$name/keys/
cp pki/ca.crt $work_dir/keys/
cp ta.key $work_dir/srv/$name/keys/
cp ta.key $work_dir/keys/
cp pki/dh.pem $work_dir/srv/$name/keys/
cp pki/dh.pem $work_dir/keys/
echo "How is port server? "
read -r
port=$REPLY
echo "How is proto server? (tcp/udp) "
read -r
proto=$REPLY
echo "How is IP server? "
read -r
ip=$REPLY
echo "How is number server? (10.60.?.0) "
read -r
num=$REPLY
sed -i "8i srv=$num" $work_dir/vpn-client-add.sh
echo "#Confiruration of openvpn server $name
port $port
proto $proto
dev tun$num
ca $name/keys/ca.crt
cert $name/keys/$name.crt
key $name/keys/$name.key  # This file should be kept secret
dh $name/keys/dh.pem
#crl-verify $name/keys/crl.pem
server 10.60.$num.0 255.255.255.0
topology subnet
client-config-dir $name/ccd
;duplicate-cn
keepalive 10 120
tls-auth $name/keys/ta.key 0 # This file is secret
cipher AES-128-CBC   # AES
comp-lzo
max-clients 30
persist-key
persist-tun
#management 127.0.0.1 1177
status /var/log/openvpn.$name-status.log
log-append  /var/log/openvpn.$name.log
verb 3
script-security 2" > $work_dir/srv/$name.conf
echo 'push "dhcp-option DNS 8.8.8.8"
push "route 10.50.1.1 255.255.255.255"' >> $work_dir/srv/$name.conf
touch $work_dir/base.conf
echo "remote $ip
proto $proto
port $port
dev tun${num}t
persist-key
persist-tun
nobind
client
pull
comp-lzo
tls-client
remote-cert-tls server
verb 3
mute 10
script-security 2
route-delay 3
cipher AES-128-CBC
key-direction 1 " > $work_dir/base.conf
cp $work_dir/binauto.sh $work_dir/srv/$name/bin/auto.sh
cp $work_dir/binman-con.sh $work_dir/srv/$name/bin/man-con.sh
cp $work_dir/auto.sh $work_dir/srv/$name/ccd/
cd $work_dir/srv/$name/ccd/
chmod +x auto.sh
source ./auto.sh $num
cd $work_dir
echo "Под каким пользователем отправить конфигурацию сервера на сервер? "
read -r
user=$REPLY
scp -r srv $user@$ip:/tmp
echo "Ключи сервера находятся в 
	$work_dir/srv/$name/keys/ca.crt
	$work_dir/srv/$name/keys/$name.crt
	$work_dir/srv/$name/keys/$name.key
	$work_dir/srv/$name/keys/ta.key
	$work_dir/srv/$name/keys/dh.pem
конфигурация сервера находится в 
	$work_dir/srv/$name.conf
Конфигурация и ключи сервера отправлены на $name ($ip) в директорию /tmp/srv.
Для создания клиентских сертификатов необходимые ключи помещены в 
	$work_dir/keys/	"

echo "DONE!"
