# TP4 Linux : Une distribution orientée serveur

## Checklist

### Définir une ip à lv vm :

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

### Connexion SSH fonctionnelle

```
[daymoove@localhost ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2021-11-23 11:04:26 CET; 26min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 861 (sshd)
    Tasks: 1 (limit: 4947)
   Memory: 3.9M
   CGroup: /system.slice/sshd.service
           └─861 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes256-cbc>
[...]
```
Clé publique ssh :

```
C:\Users\Robert\.ssh>type id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
```

Fichier authorized_keys de la VM :

```
[daymoove@localhost ~]$ cat /home/daymoove/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDByU/DmFwu/0Hn98/5GjQetu+UCfI2BbbXESCtfeT95uRxaGIzKyS3DxaAcXPGKPKxY5e/Hdbjef39ZllokEvoDu2U3h5IhnyuW94yWm6xIqwmrTXg/V45OZsZunMDe1VY/2nbalq1RRwJEDjBUeictJlGvsTyFLlLe2Hh93oDwmNNg2Vho2Feh1zDPHyFsJMGzm9q9McvMKUMNFBAnpb2A6kMZgXeHMDAKwIwg5RGbVnSJwM3UNH3DySUgQN6RLEtp/vKTHN8WIc0GRJrTS0KeAikguIs6JodQQyART2j9jPtOJ3f/tO5oStsb1ud/03uulLw49IOcjRx6oI7bP8uoeGGwdjuOSo1dYB6ykyTerhkNJiLXpGFTeegdnhr5C8w33fqgRTS4e1C1MGYuB+a8lFfAA8SpAQAoEI2tBlr2/02Rq6irsMCAIlAn0QM2gG/8RahHLY9LMz1Y+vk2AB0J6ARWsSu98SM7QJdCxruQnGjrcdeRRSA2AMsliilf/kq2qstTJtK8/aPs/MJqDBUYgVfIZTYBDVgY5cqgNFNSpAqZSUW6oCIaqRpq7ks2YT3SXpeENie8cFSpzuBEjPmKiL6qz8NqpvHAtLrqauNg/HOZsYa5iENOLe7gSSHKXL0+7mWnM0kZz60ShsPllhKR/XPPYbCgbLV6yki4KWtUQ== robert@LAPTOP-CEVL96TB
```

### accès internet

```
[daymoove@localhost ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=113 time=24.5 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=113 time=27.8 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=113 time=27.2 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=113 time=26.3 ms
```

### résolution de nom

```
[daymoove@localhost ~]$ ping genshin.gg
PING genshin.gg (3.67.49.128) 56(84) bytes of data.
64 bytes from ec2-3-67-49-128.eu-central-1.compute.amazonaws.com (3.67.49.128): icmp_seq=1 ttl=46 time=30.5 ms
64 bytes from ec2-3-67-49-128.eu-central-1.compute.amazonaws.com (3.67.49.128): icmp_seq=2 ttl=46 time=31.1 ms
64 bytes from ec2-3-67-49-128.eu-central-1.compute.amazonaws.com (3.67.49.128): icmp_seq=3 ttl=46 time=32.10 ms
64 bytes from ec2-3-67-49-128.eu-central-1.compute.amazonaws.com (3.67.49.128): icmp_seq=4 ttl=46 time=30.7 ms
```

### Définir le nom de la machine

```
[daymoove@localhost ~]$ cat /etc/hostname
node1.tp4.linux
```

```
[daymoove@localhost ~]$ hostname
node1.tp4.linux
```

## Mettre en place un service

### install

```
sudo dnf install nginx
```

sortie :

```
[...]
  perl-Scalar-List-Utils-3:1.49-2.el8.x86_64
  perl-Socket-4:2.027-3.el8.x86_64
  perl-Storable-1:3.11-3.el8.x86_64
  perl-Term-ANSIColor-4.06-396.el8.noarch
  perl-Term-Cap-1.17-395.el8.noarch
  perl-Text-ParseWords-3.30-395.el8.noarch
  perl-Text-Tabs+Wrap-2013.0523-395.el8.noarch
  perl-Time-Local-1:1.280-1.el8.noarch
  perl-URI-1.73-3.el8.noarch
  perl-Unicode-Normalize-1.25-396.el8.x86_64
  perl-constant-1.33-396.el8.noarch
  perl-interpreter-4:5.26.3-420.el8.x86_64
  perl-libnet-3.11-3.el8.noarch
  perl-libs-4:5.26.3-420.el8.x86_64
  perl-macros-4:5.26.3-420.el8.x86_64
  perl-parent-1:0.237-1.el8.noarch
  perl-podlators-4.11-1.el8.noarch
  perl-threads-1:2.21-2.el8.x86_64
  perl-threads-shared-1.58-2.el8.x86_64

Complete!
```

### Analyse

```
[daymoove@localhost ~]$ ps -ef | grep nginx
root        8183       1  0 12:00 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       8184    8183  0 12:00 ?        00:00:00 nginx: worker process
```

Le processus du service nginx tourne sous l'utilisateur nginx.

```
[daymoove@localhost ~]$ ss -lptu | grep http
tcp   LISTEN 0      128          0.0.0.0:http      0.0.0.0:*
tcp   LISTEN 0      128             [::]:http         [::]:*
```

```
[daymoove@localhost ~]$ ss -lntr | grep 80
LISTEN 0      128          0.0.0.0:80        0.0.0.0:*
LISTEN 0      128             [::]:80           [::]:*
```

Le serveur web écoute derrière le port 80.

```
[daymoove@localhost nginx]$ cat nginx.conf | grep root
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;
```

La racine web se situe dans le dossier ```/usr/share/nginx/html```

```
[daymoove@localhost html]$ ls -al
total 20
drwxr-xr-x. 2 root root   99 Nov 23 11:59 .
drwxr-xr-x. 4 root root   33 Nov 23 11:59 ..
-rw-r--r--. 1 root root 3332 Jun 10 11:09 404.html
-rw-r--r--. 1 root root 3404 Jun 10 11:09 50x.html
-rw-r--r--. 1 root root 3429 Jun 10 11:09 index.html
-rw-r--r--. 1 root root  368 Jun 10 11:09 nginx-logo.png
-rw-r--r--. 1 root root 1800 Jun 10 11:09 poweredby.png
```

### Visite du service web

**Configuration du firewall :**

```
[daymoove@localhost html]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
```

```
[daymoove@localhost html]$ sudo firewall-cmd --reload
success
```

**Tester le bon fonctionnement du service**

Sur le PC :

```
C:\Users\Robert>curl http://10.200.1.69:8080
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>Test Page for the Nginx HTTP Server on Rocky Linux</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
      /*<![CDATA[*/
      body {
        background-color: #fff;
        color: #000;
        font-size: 0.9em;
        font-family: sans-serif, helvetica;
        margin: 0;
        padding: 0;
[...]
```

### Modif de la conf du serveur web

**Changer le port d'écoute**

```
[daymoove@localhost nginx]$ cat nginx.conf
        listen       8080 default_server;
        listen       [::]:8080 default_server;
```

```
[daymoove@localhost nginx]$ ss -lntr | grep 80
LISTEN 0      128          0.0.0.0:8080      0.0.0.0:*
LISTEN 0      128             [::]:8080         [::]:*
```

```
[daymoove@localhost nginx]$ ss -lptu | grep webcache
tcp   LISTEN 0      128          0.0.0.0:webcache      0.0.0.0:*
tcp   LISTEN 0      128             [::]:webcache         [::]:*
```

```
[daymoove@localhost nginx]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
```

```
[daymoove@localhost nginx]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
```

```
[daymoove@localhost nginx]$ sudo firewall-cmd --reload
success
```

```
C:\Users\Robert>curl http://10.200.1.69:8080
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>Test Page for the Nginx HTTP Server on Rocky Linux</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
      /*<![CDATA[*/
      body {
        background-color: #fff;
        color: #000;
        font-size: 0.9em;
        font-family: sans-serif, helvetica;
        margin: 0;
        padding: 0;
[...]
```

**Changer l'utilisateur qui lance le service**

Créer un nouvel utilisateur :
```
[daymoove@localhost nginx]$ sudo useradd -d /home/web -p toto web
```

Modification du fichier NGINX :
```
[daymoove@localhost nginx]$ cat nginx.conf
[...]
user web;
[...]
```
```
sudo systemctl restart nginx
```

```
[daymoove@localhost nginx]$ ps -ef | grep web
web         8445    8444  0 12:45 ?        00:00:00 nginx: worker process
```

**Changer l'emplacement de la racine Web**

```
[daymoove@localhost nginx]$ sudo mkdir /var/www/
```

```
[daymoove@localhost nginx]$ sudo mkdir /var/www/super_site_web
```

```
sudo vi /var/www/super_site_web/index.html
```

```
[daymoove@node1 ~]$ sudo cat /var/www/super_site_web/index.html
<html>
        <head>

                <h1>toto</h1>

        </head>
</html>
```

On fait en sorte que le dossier et son contenue appartiennent à l'utilisateur : web.
```
sudo chown web super_site_web/
```

```
[daymoove@localhost super_site_web]$ ls -al
[...]
drwxr-xr-x.  2 web  root   24 Nov 23 12:52 super_site_web
```

```
sudo chown web index.html
```

```
[daymoove@localhost super_site_web]$ ls -al
[...]
-rw-r--r--. 1 web  root 14 Nov 23 12:52 index.htm
```

```
sudo vi /etc/nginx/nginx.conf
```

```
[daymoove@node1 ~]$cat /etc/nginx/nginx.conf
[...]
root         /var/www/super_site_web;
[...]
```

```
systemctl restart nginx.service
```


Sur le PC :
S
```
C:\Users\Robert>curl http://10.200.1.69:8080
<html>
        <head>

                <h1>toto</h1>

        </head>
</html>
```
