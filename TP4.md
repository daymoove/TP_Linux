# TP4 Linux : Une distribution orientée serveur

## Checklist

### définir une ip à lv vm :

**Contenu fichier conf :**
```
[daymoove@localhost ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
TYPE=Ethernet
BOOTPROTO=static
NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
IPADDR=10.200.1.69
NETMASK=255.255.255.0
```

```ip a```

sortie :
```
[...]
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:86:89:96 brd ff:ff:ff:ff:ff:ff
    inet 10.200.1.69/24 brd 10.200.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe86:8996/64 scope link
       valid_lft forever preferred_lft forever
```
