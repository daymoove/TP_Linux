# TP2 : Manipulation de services
Joseph SELVA B1A

## prérequis
**Nommer la machine**

Pour changer un nom jusqu'au redémarage de la machine on fait:

```
sudo hostname node1.tp2.linux
daymoove@node1:~$
```

Pour changer le nom même après redémarage on fait:

```
sudo nano /etc/hostname
cat /etc/hostname
node1.tp2.linux
```

**Config réseau**

Pour vérifier que les cartes réseaux est toute une ip on fait:

```
ip a


[...]
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:c3:ef:4e brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.134/24 brd 192.168.56.255 scope global dynamic noprefixroute enp0s8
       valid_lft 369sec preferred_lft 369sec
    inet6 fe80::7fd7:3774:d011:5726/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

Puis on vérifie que la configuration est correcte en faisant des commandes ping.


```
ping 1.1.1.1

64 bytes from 1.1.1.1: icmp_seq=1 ttl=50 time=74.8 ms
64 bytes from 1.1.1.1: icmp_seq=1 ttl=50 time=66.4 ms
64 bytes from 1.1.1.1: icmp_seq=1 ttl=50 time=54.1 ms
64 bytes from 1.1.1.1: icmp_seq=1 ttl=50 time=43.5 ms
```


```
ping ynov.com

64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=1 ttl=50 time=21.3 ms
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=2 ttl=50 time=21.0 ms
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=3 ttl=50 time=21.8 ms
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=4 ttl=50 time=21.3 ms
```


```
ping 192.168.56.134

Réponse de 192.168.56.134 : octets=32 temps<1ms TTL=64
Réponse de 192.168.56.134 : octets=32 temps<1ms TTL=64
Réponse de 192.168.56.134 : octets=32 temps<1ms TTL=64
Réponse de 192.168.56.134 : octets=32 temps<1ms TTL=64
```

## Partie 1 : SSH
**Installation du serveur**

On installe ssh avec 
```
sudo apt install openssh-server

reading package list... Done
Building dependency tree
Reading state information... Done
openssh-server is already the newest version (1:8.2p1-4ubuntu0.3).
0 upraded, 0 newly installed, 0 to remove and 89 not upgraded.
```

On peut voir les dosiers de configuration de ssh dans:

```
cd /etc/ssh/

ls

moduli      ssh_config.d  sshd_config.d       ssh_host_ecdsa_key.pub  ssh_host_ed25519_key.pub  ssh_host_rsa_key.pub
ssh_config  sshd_config   ssh_host_ecdsa_key  ssh_host_ed25519_key    ssh_host_rsa_key          ssh_import_id

```

**Lancement du service SSH**

On démarre le service avec:
```
sudo systemctl start sshd

Authentication is required to start 'ssh.service'.
Authenticating as: daymoove,,, (daymoove)
Password:
```
 
Puis on vérifie que le service fonctionne avec:
```
sudo systemctl status sshd

 ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 10:51:33 CEST; 49min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 533 (sshd)
      Tasks: 1 (limit: 2312)
     Memory: 4.1M
     CGroup: /system.slice/ssh.service
             └─533 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
[...]
```

**Etude du service SSH**

On affiche le statut du service avec:
```
sudo systemctl status sshd

 ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 10:51:33 CEST; 49min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 533 (sshd)
      Tasks: 1 (limit: 2312)
     Memory: 4.1M
     CGroup: /system.slice/ssh.service
             └─533 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
[...]
```

On affiche les processus avec:
```
ps aux

[...]
root       13841  0.0  0.4  13992  8420 ?        Ss   11:37   0:00 sshd: daymoove [priv]
daymoove   13898  0.0  0.2  14124  5720 ?        S    11:37   0:00 sshd: daymoove@pts/2
[...]
```

On affiche le ports utilisé avec:
```
ss -l

[...]
tcp      LISTEN    0         128                                                [::]:ssh                                 [::]:*
[...]
```
On affiche les logs avec:
```
journalctl -xe -u ssh

[...]
oct. 25 11:09:19 node1.tp2.linux sshd[1378]: Invalid user node1 from 192.168.56.1 port 64653
oct. 25 11:09:21 node1.tp2.linux sshd[1378]: pam_unix(sshd:auth): check pass; user unknown
oct. 25 11:09:21 node1.tp2.linux sshd[1378]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=192.168.56.1
oct. 25 11:09:23 node1.tp2.linux sshd[1378]: Failed password for invalid user node1 from 192.168.56.1 port 64653 ssh2
[...]

```

On se connecte au serveur ssh avec le pc avec:
```
ssh daymoove@192.168.56.134

Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-38-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

51 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Mon Oct 25 11:37:54 2021 from 192.168.56.1

```

**Modification de la configuration du serveur**

Pour modifier le port d'écoute on fait:
```
sudo nano /etc/ssh/sshd_config
```
Dans ce fichier on change le port d'écoute pour un nombre entre 1025 et 65536
```
cat /etc/ssh/sshd_config
```
```
[...]
Port 5522
[...]
```
```
ss -l
```
```
[...]
tcp   LISTEN 0      128                                          [::]:5522                           [::]:*

```

Une fois la modification effectué, pour se connecter à la vm on fait:
```
ssh -p 5522 daymoove@192.168.56.134
```

## Partie 2 : FTP
**Installation du serveur**

On installe le serveur avec:
```
sudo apt install vsftpd

[...]
The following NEW packages will be installed
vsftpd
[...]
```
On peut voir le dossier de configuration via:
```
cd etc

ls

[...]
vsftpd.conf
[...]
```

**Lancement du service FTP**

On démarre le service avec:
```
systemctl start vsftpd

Authentication is required to start 'vsftpd.service'.
Authenticating as: daymoove,,, (daymoove)
Password:
```

On vérifie son que le service est actif avec:
```
systemctl status vsftpd

vsftpd.service - vsftpd FTP server
     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-11-03 23:29:25 CET; 7min ago
   Main PID: 30530 (vsftpd)
      Tasks: 1 (limit: 2312)
     Memory: 528.0K
     CGroup: /system.slice/vsftpd.service
             └─30530 /usr/sbin/vsftpd /etc/vsftpd.conf
[...]
```

**Etude du service FTP**

On affiche le statut du service avec:
```
systemctl status vsftpd

vsftpd.service - vsftpd FTP server
     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-11-03 23:29:25 CET; 7min ago
   Main PID: 30530 (vsftpd)
      Tasks: 1 (limit: 2312)
     Memory: 528.0K
     CGroup: /system.slice/vsftpd.service
             └─30530 /usr/sbin/vsftpd /etc/vsftpd.conf
[...]
```

On affiche les processus avec:
```
ps aux

root       30530  0.0  0.1   6816  3044 ?        Ss   23:29   0:00 /usr/sbin/vsftpd /etc/vsftpd.conf
```

On affiche le port utilisé avec:
```
sudo ss -ltpn

LISTEN   0        32                      *:21                    *:*       users:(("vsftpd",pid=30530,fd=3))
```

On affiche les logs avec:
```
journalctl -xe -u vsftpd

[...]
- The job identifier is 6351.
nov. 03 23:29:25 node1.tp2.linux systemd[1]: Started vsftpd FTP server.
-- Subject: A start job for unit vsftpd.service has finished successfully
[...]
```

Pour se connecter au serveur on fait
```
ftp> open
(to) 192.168.56.134
Connected to 192.168.56.134.
220 (vsFTPd 3.0.3)
Name (192.168.56.134:daymoove): daymoove
331 Please specify the password.
Password:
230 Login successful.
```

Pour download:
```
get tp2.txt

[...]
150 Opening BINARY mode data connection for tp2.txt (6 bytes).
226 Transfer complete
```

Pour upload:
Il faut modifier le fichier vsftpd.conf
```
sudo nano /etc/vsftpd.conf
```
on enlève le # devant #write_enable=YES

On peut ensuite upload avec:
```
put tp2.txt

[...]
150 Ok to send data.
226 Transfer complete.
```

On vérifie que cela fonctionneen faisant ls dans le dossier de l'upload(ici le dossier utilisateur).
```
ls

Desktop  Documents  Downloads  tp2.txt  Music  Pictures  Public  Templates  Videos
```
On vérifie les logs en regardants dans le fichier
```
sudo cat var/log/vsftpd.log
```
Pour le download:
```
Fri Nov  5 21:43:45 2021 [pid 35179] [daymoove] OK DOWNLOAD: Client "::ffff:192.168.56.134", "/home/daymoove/tp2.txt", 6 bytes, 7.85Kbyte/sec
```
Pour l'upload:
```
Fri Nov  5 21:52:06 2021 [pid 35266] [daymoove] OK UPLOAD: Client "::ffff:192.168.56.134", "/home/daymoove/tp2.txt", 0.00Kbyte/s
```

**Modification de la configuration du serveur**

Pour modifier le port on fait:
```
sudo nano /etc/vsftpd.conf
```
On ajoute la ligne listen_port=.
```
listen=NO
listen_port=2121
```
```
cat /etc/vsftpd.conf

[...]
listen_port=2121
[...]
```

On vérifie la modification avec:
```
sudo ss -ltpn

[...]
LISTEN   0        32                     *:2121                   *:*       users:(("vsftpd",pid=35375,fd=3))
```

Pour ouvrir ensuite on fait:
```
ftp> open 192.168.56.134 2121
[...]

[...]
230 Login successful.
[...]
```

## Partie 3 : Création de votre propre service
**Jouer avec netcat**

On installe netcat avec:
```
sudo apt-get install netcat

[...]
The following NEW packages will be installed:
  netcat
[...]
```

Pour créer un chat on fait les commandes:

Sur la VM:
```
nc -l -p 12345
```
Sur le Pc:
```
nc 192.168.56.134 12345
```

Pour stocker les données échangées dans un fichier
on fait:

Sur la VM:
```
nc -l -p 12345 > tp2.txt
```

Sur le pc:
```
nc 192.168.56.134 12345
hello
```

```
cat tp2.txt
hello
```

**Créer le service**
On crée chat_tp2.service dans le dossier /etc/systemd/system.
```
cd /etc/systemd/system
sudo touch chat_tp2.service
```

On lui ajoute les permissions:
```
sudo chmod 777 chat_tp2.service
```

Puis on modifie le fichier avec le contenue pour créer le service.
```
sudo nano chat_tp2.service
```
```
cat chat_tp2.service
[Unit]
Description=Little chat service (TP2)

[Service]
ExecStart=/usr/bin/nc -l -p 12345

[Install]
WantedBy=multi-user.target
```

**Test test et retest**

On démarre le system avec:
```
systemctl start chat_tp2

Authentication is required to start 'chat_tp2.service'.
Authenticating as: daymoove,,, (daymoove)
Password:
```

On vérifie qu'il est lancé avec:
```
systemctl status chat_tp2

● chat_tp2.service - Little chat service (TP2)
     Loaded: loaded (/etc/systemd/system/chat_tp2.service; disabled; vendor preset: enabled)
     Active: active (running) since Thu 2021-11-04 21:05:20 CET; 1min 50s ago
   Main PID: 34129 (nc)
      Tasks: 1 (limit: 2312)
     Memory: 188.0K
     CGroup: /system.slice/chat_tp2.service
             └─34129 /usr/bin/nc -l -p 1
[...]
```
On vérifie qu'il écoute bien le bon port:
```
ss -l
```
```
tcp   LISTEN 0      1                                         0.0.0.0:12345                       0.0.0.0:*

```

On se connecte depuis le pc:
```
nc 192.168.56.134 12345
hello
```

On visualise ensuite les messages envoyé avec 
```
journalctl -xe -u chat_tp2
```
ou
```
systemctl status chat_tp2
```
```
[...]
nov. 04 21:09:58 node1.tp2.linux nc[34159]: hello
[...]
```