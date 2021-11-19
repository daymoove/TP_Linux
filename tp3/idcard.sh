#!/usr/bin/env bash
hostname=$(hostname)
nom_de_os=$(grep ^NAME= /etc/os-release | cut -d'"' -f2)
kernel_version=$(uname -r)
ip=$(hostname -I | cut -d' ' -f2)
total_RAM=$(free -mh | grep Mem: | cut -d' ' -f11)
RAM_dispo=$(free -mh | grep Mem: | cut -d' ' -f46)
disque=$(df -h /dev/sda5 | grep /dev | cut -d' ' -f12)
j=1
url_cat=$(curl -s https://api.thecatapi.com/v1/images/search | grep '"url"' | cut -d'"' -f10)
echo -n "Machine name : ";echo "$hostname"
echo -n "OS "; echo -n "$nom_de_os"; echo -n " and kernel version is "; echo "$kernel_version"
echo -n "IP : "; echo "$ip"
echo -n "RAM : "; echo -n "$RAM_dispo"; echo -n " RAM restante sur "; echo -n "$total_RAM"; echo " RAM totale"
echo -n "Disque : "; echo -n "$disque"; echo " space left"
echo "Top 5 processes by RAM usage :"
for i in {2..6}; do
        top_RAM=$(ps -o %mem,command ax | sort -r -b | head -"$i" | tail -1)
        echo -n "  - "; echo "$top_RAM"
done
echo "Listening ports : "
ss -lntu | grep LISTEN | while read line; do
        port=$(ss -lntu | grep LISTEN | cut -d']' -f2 | cut -d':' -f2 | cut -d' ' -f1 | head -$j | tail -1)
        nom_port=$(ss -lptu | grep LISTEN | cut -d']' -f2 | cut -d':' -f2 | cut -d' ' -f1 | head -$j | tail -1)
        echo -n "  - "; echo -n "$port"; echo -n " : "; echo "$nom_port"
        ((j=j+1))
done
echo -n "Here's your random cat : "; echo "$url_cat"