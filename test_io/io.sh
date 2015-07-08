#!/bin/bash


if test -f "/tmp/test.data";
then rm -f /tmp/*.data; echo -e "controle fichier test.data : \033[32;1mok \033[0m";
else echo -e "controle fichier test.data : \033[32;1mok \033[0m";
fi

if [ ! -f "/tmp/test.data" ] ;
then echo -e "vérification purge fichier test.data : \033[32;1mok \033[0m";
fi

function test_io {

dd if=/dev/zero of=/tmp/test.data bs=4096 count=2000 conv=fdatasync  2> /tmp/resultdd.txt

awk 'END {print}' /tmp/resultdd.txt >/tmp/resultdd2.txt

cat /tmp/resultdd2.txt | awk -F " " '{print $8}' |tee -a  /tmp/resultddfinal.txt

}

for i in {1..10}; do test_io ; done

awk '{ total += $1 } END { print total/NR }'  /tmp/resultddfinal.txt


