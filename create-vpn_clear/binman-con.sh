#!/usr/bin/python

import sys
import telnetlib
import os

host="127.0.0.1"
telnet_port=1177
loc_ret=""

if len(sys.argv)<2:
        print("Usage:")
        print(sys.argv[0] + " <params>")
        sys.exit(0)

arguments=" ".join(sys.argv[1:])

tn = telnetlib.Telnet(host,telnet_port)

loc_ret=tn.read_until(">INFO:OpenVPN Management Interface Version 1 -- type 'help' for more info")
if not loc_ret:
        print("Error after enter")
        sys.exit(4)

tn.write(arguments + "\n")

loc_ret=tn.read_until("END",2)
if not loc_ret:
        print("Error after conf t command")
        sys.exit(4)
print(loc_ret)

tn.write("exit\n")
loc_ret=tn.read_until("#",2)
if not loc_ret:
        print("Error after exit command")
        sys.exit(6)
tn.close


