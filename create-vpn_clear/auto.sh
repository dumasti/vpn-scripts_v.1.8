#!/bin/bash

numb=$1
if [[ "$numb" -ge 1 && "$numb" -lt 10 ]]; then
    name=cli00$numb
    elif [[ "$numb" -ge 10 && "$numb" -lt 99 ]]; then
    name=cli0$numb
    elif [[ "$numb" -ge 100 && "$numb" -lt 256 ]]; then
    name=cli$numb
fi
echo "ifconfig-push 10.60.$numb.$x 255.255.255.0" > ${name}001 
echo 'push "redirect-gateway def1"' >> ${name}001
x=2
while [ $x -lt 10 ]
do
	echo "ifconfig-push 10.60.$numb.$x 255.255.255.0" > ${name}00$x
	x=$(( $x + 1 ))
done
x=10
while [ $x -lt 100 ]
do
	echo "ifconfig-push 10.60.$numb.$x 255.255.255.0" > ${name}0$x
	x=$(( $x + 1 ))
done
x=100
while [ $x -lt 251 ]
do
	echo "ifconfig-push 10.60.$numb.$x 255.255.255.0" > ${name}$x
	echo 'push "redirect-gateway def1"' >> ${name}$x
	x=$(( $x + 1 ))
done
