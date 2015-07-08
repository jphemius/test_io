#!/bin/bash

echo "Combien de test voulez-vous effectuer ?"

read nombre

echo -e "controle presence fichier traitement : \033[32;1mok \033[0m"

controlfile=`for i in /tmp/result*; do test -f "$i" && ls /tmp/result* |wc -l  && break; done`

[ -z "$controlfile" ] && echo "Empty" || rm -f /tmp/resultdd* ;echo -e "suppression fichier traitement : \033[32;1mok \033[0m"


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

cat /tmp/resultdd2.txt | awk -F " " '{print $8}' >> /tmp/resultddfinal.txt

}

echo -e "traitement du test d'écriture : \033[32;1men cours \033[0m"

for i in $(seq 1 $nombre); do test_io ; done

echo -e "traitement du test d'écriture : \033[32;1mterminé \033[0m"

oresult=`awk '{ total += $1 } END { print total/NR }'  /tmp/resultddfinal.txt`

echo -e "La vitesse moyenne d'écriture sur $nombre test(s) d'écriture est de $oresult Mbp/s"

