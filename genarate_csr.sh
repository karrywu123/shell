#!/bin/bash

read -p "please input ssl domain: " domain

if [ -e $domain ];then
 echo "Directionary $domain exist!"
 exit 1
fi
 
mkdir /home/ansiblemanage/ssl/$domain 
cd /home/ansiblemanage/ssl/$domain
openssl req -new -newkey rsa:2048 -nodes -keyout $domain.key -out $domain.csr
ls 
