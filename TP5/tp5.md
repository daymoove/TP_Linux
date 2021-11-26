# TP5 : P'tit cloud perso

## I. Setup DB

### 1. Install MariaDB

**Installer MariaDB sur la machine db.tp5.linux**

```
[daymoove@localhost ~]$ sudo dnf install mariadb-server

Rocky Linux 8 - AppStream                                                                12 kB/s | 4.8 kB     00:00
Rocky Linux 8 - AppStream                                                               2.3 MB/s | 8.2 MB     00:03
Rocky Linux 8 - BaseOS                                                                   10 kB/s | 4.3 kB     00:00
Rocky Linux 8 - BaseOS                                                                  2.0 MB/s | 3.5 MB     00:01
Rocky Linux 8 - Extras                                                                  9.3 kB/s | 3.5 kB     00:00
Rocky Linux 8 - Extras                                                                   18 kB/s |  10 kB     00:00
Dependencies resolved.
[...]
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
  psmisc-23.1-5.el8.x86_64

Complete!
```

**Le service MariaDB**
```
[daymoove@localhost ~]$ sudo systemctl start mariadb
```

```
[daymoove@localhost ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
```

```
[daymoove@localhost ~]$ sudo systemctl status mariadb
● mariadb.service - MariaDB 10.3 database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-11-25 11:52:17 CET; 1min 32s ago
     Docs: man:mysqld(8)
           https://mariadb.com/kb/en/library/systemd/
 Main PID: 4927 (mysqld)
   Status: "Taking your SQL requests now..."
    Tasks: 30 (limit: 4947)
   Memory: 79.7M
   CGroup: /system.slice/mariadb.service
           └─4927 /usr/libexec/mysqld --basedir=/usr
[...]
```

```
[daymoove@localhost ~]$ ss -ltrp
State        Recv-Q        Send-Q               Local Address:Port                Peer Address:Port       Process
LISTEN       0             128                        0.0.0.0:ssh                      0.0.0.0:*
LISTEN       0             80                               *:mysql                          *:*
LISTEN       0             128                           [::]:ssh                         [::]:*
```

```
[daymoove@localhost ~]$ ss -lntr
State         Recv-Q        Send-Q               Local Address:Port               Peer Address:Port       Process
LISTEN        0             128                        0.0.0.0:22                      0.0.0.0:*
LISTEN        0             80                               *:3306                          *:*
LISTEN        0             128                           [::]:22                         [::]:*
```

Le numéro de port est 3306 et le processus qui écoute drrière est mysql.

ps -ef | grep mysql
mysql       4927       1  0 11:52 ?        00:00:00 /usr/libexec/mysqld --basedir=/usr
[...]

Le procesus mysql tourne sous l'user mysql.


**Firewall**
```
[daymoove@localhost ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
```

```
[daymoove@localhost ~]$ sudo firewall-cmd --reload
success
```

### 2. Conf MariaDB

**Configuration élémentaire de la base**

```
mysql_secure_installation
```

Question 1: Entrée le mot de passe actuel :
réponse: Entrée, pour en créer un nouveau.

Question 2: Mettre un mot de passe à root ?
réponse: yes, pour définir un mot de passe.

Question 3: Suprimer l'user anonyme ?
réponse: yes, car l'utilisteur anonyme peut être utilisé par n'importe qui.

Question 4: Désactiver la conexion à distance du root ?
réponse: yes, pour se connecter à root uniquement en localhost.

Question 5: Suprimer la database de test ?
réponse: yes, car elle est accescible par des utilisateurs anonymes

Question 6: Changer les paramètres maintenants ?
réponse: yes

**Préparation de la base en vue de l'utilisation par NextCloud**

```
[daymoove@localhost ~]$ sudo mysql -u root -p
Enter password:
```

```
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 19
Server version: 10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

```
MariaDB [(none)]> CREATE USER 'nextcloud'@'10.5.1.11' IDENTIFIED BY 'meow';
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.5.1.11';
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]> exit
Bye
```

### 3. Test

**Installez sur la machine web.tp5.linux la commande mysql**

```
[daymoove@web ~]$ dnf provides mysql
Rocky Linux 8 - AppStream                                                               2.3 MB/s | 8.2 MB     00:03
Rocky Linux 8 - BaseOS                                                                  2.0 MB/s | 3.5 MB     00:01
Rocky Linux 8 - Extras                                                                   15 kB/s |  10 kB     00:00
mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64 : MySQL client programs and shared libraries
Repo        : appstream
Matched from:
Provide    : mysql = 8.0.26-1.module+el8.4.0+652+6de068a7
```

```
[daymoove@web ~]$ sudo dnf install mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64
Last metadata expiration check: 0:01:45 ago on Thu 25 Nov 2021 12:30:22 PM CET.
Dependencies resolved.
[...]
Installed:
  mariadb-connector-c-config-3.1.11-2.el8_3.noarch               mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64
  mysql-common-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64

Complete!
```

**Tester la connexion**

```
[daymoove@web ~]$ mysql -u nextcloud -h 10.5.1.12 -P 3306 -D nextcloud -p
Enter password:meow
```

```
Welcome to the MySQL monitor.  Commands end with ; or \g

mysql> show tables;
Empty set (0.00 sec)
```

## II. Setup Web

### 1. Install Apache

##### A. Apache

**Installer Apache sur la machine web.tp5.linux**

```
sudo dnf install httpd
[...]
Installed:
  apr-1.6.3-12.el8.x86_64
  apr-util-1.6.1-6.el8.1.x86_64
  apr-util-bdb-1.6.1-6.el8.1.x86_64
  apr-util-openssl-1.6.1-6.el8.1.x86_64
  httpd-2.4.37-43.module+el8.5.0+714+5ec56ee8.x86_64
  httpd-filesystem-2.4.37-43.module+el8.5.0+714+5ec56ee8.noarch
  httpd-tools-2.4.37-43.module+el8.5.0+714+5ec56ee8.x86_64
  mod_http2-1.15.7-3.module+el8.5.0+695+1fa8055e.x86_64
  rocky-logos-httpd-85.0-3.el8.noarch

Complete!
```

**Analyse du service Apache**

```
[daymoove@web ~]$ sudo systemctl start httpd
```

```
[daymoove@web ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```

```
[daymoove@web ~]$ ps -ef | grep httpd
root        2040       1  0 09:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2041    2040  0 09:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2042    2040  0 09:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2043    2040  0 09:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      2044    2040  0 09:19 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
```

```
[daymoove@web ~]$ ss -lntr
State         Recv-Q        Send-Q               Local Address:Port                Peer Address:Port        Process
LISTEN        0             128                        0.0.0.0:22                       0.0.0.0:*
LISTEN        0             128                              *:80                             *:*
LISTEN        0             128                           [::]:22                          [::]:*
```

```
[daymoove@web ~]$ ss -lptr
State         Recv-Q        Send-Q               Local Address:Port                Peer Address:Port        Process
LISTEN        0             128                        0.0.0.0:ssh                      0.0.0.0:*
LISTEN        0             128                              *:http                           *:*
LISTEN        0             128                           [::]:ssh                         [::]:*
```

Les procesus apache sont lancé sous l'user apache.

Apache écoute sur le port 80.


**Un premier test**

```
[daymoove@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
```

```
[daymoove@web ~]$ sudo firewall-cmd --reload
success
```

Sur le PC :

```
C:\Users\Robert>curl http://10.5.1.11:80
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
        height: 100%;
        width: 100%;
[...]
```

#### B. PHP

**Installer PHP**

```
[daymoove@web ~]$ sudo dnf install epel-release
Last metadata expiration check: 20:47:40 ago on Thu 25 Nov 2021 12:44:23 PM CET.
Dependencies resolved.
[...]
```

```
[daymoove@web ~]$ sudo dnf update
Extra Packages for Enterprise Linux 8 - x86_64                                             8.2 MB/s |  11 MB     00:01
Extra Packages for Enterprise Linux Modular 8 - x86_64                                     1.1 MB/s | 958 kB     00:00
Last metadata expiration check: 0:00:01 ago on Fri 26 Nov 2021 09:32:18 AM CET.
Dependencies resolved.
Nothing to do.
Complete!
```

```
[daymoove@web ~]$ sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
Last metadata expiration check: 0:00:12 ago on Fri 26 Nov 2021 09:32:18 AM CET.
remi-release-8.rpm                                                                         166 kB/s |  26 kB     00:00
Dependencies resolved.
[...]
```

```
[daymoove@web ~]$ sudo dnf module enable php:remi-7.4
Remi's Modular repository for Enterprise Linux 8 - x86_64                                  2.6 kB/s | 858  B     00:00
Remi's Modular repository for Enterprise Linux 8 - x86_64                                  3.0 MB/s | 3.1 kB     00:00
Importing GPG key 0x5F11735A:
[...]
```

```
[daymoove@web ~]$ sudo dnf install zip unzip libxml2 openssl php74-php php74-php-ctype php74-php-curl php74-php-gd php74-php-iconv php74-php-json php74-php-libxml php74-php-mbstring php74-php-openssl php74-php-posix php74-php-session php74-php-xml php74-php-zip php74-php-zlib php74-php-pdo php74-php-mysqlnd php74-php-intl php74-php-bcmath php74-php-gmp
Last metadata expiration check: 0:00:24 ago on Fri 26 Nov 2021 09:33:06 AM CET.
Package zip-3.0-23.el8.x86_64 is already installed.
Package unzip-6.0-45.el8_4.x86_64 is already installed.
Package libxml2-2.9.7-11.el8.x86_64 is already installed.
Package openssl-1:1.1.1k-4.el8.x86_64 is already installed.
[...]
```

### 2. Conf Apache

**Analyser la conf Apache**

```
[daymoove@web ~]$ cat /etc/httpd/conf/httpd.conf | grep .d
[...]
# Load config files in the "/etc/httpd/conf.d" directory, if any.
IncludeOptional conf.d/*.conf
```

**Créer un VirtualHost qui accueillera NextCloud**

```
[daymoove@web conf.d]$ sudo vi nextcloud.conf
```

```
[daymoove@web conf.d]$ cat nextcloud.conf
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/html/

  ServerName  web.tp5.linux

  <Directory /var/www/nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

**Configurer la racine web**

```
sudo mkdir nextcloud
```

```
[daymoove@web www]$ ls
cgi-bin  html  nextcloud
```

```
sudo mkdir nextcloud/html
```

```
[daymoove@web www]$ cd nextcloud/
```

```
[daymoove@web nextcloud]$ ls
html
```

```
[daymoove@web nextcloud]$ sudo chown apache html/
```

```
[daymoove@web nextcloud]$ ls -al
total 0
drwxr-xr-x. 3 apache root 18 Nov 26 10:05 .
drwxr-xr-x. 5 root   root 50 Nov 26 10:05 ..
drwxr-xr-x. 2 apache root  6 Nov 26 10:05 html
```

```
[daymoove@web www]$ sudo chown apache nextcloud/
```

```
[daymoove@web www]$ ls -al
total 4
drwxr-xr-x.  5 root   root   50 Nov 26 10:05 .
drwxr-xr-x. 22 root   root 4096 Nov 26 09:16 ..
drwxr-xr-x.  2 root   root    6 Nov 15 04:13 cgi-bin
drwxr-xr-x.  2 root   root    6 Nov 15 04:13 html
drwxr-xr-x.  3 apache root   18 Nov 26 10:05 nextcloud
```

**Configurer PHP**

```
[daymoove@web www]$ timedatectl
               Local time: Fri 2021-11-26 10:13:27 CET
           Universal time: Fri 2021-11-26 09:13:27 UTC
                 RTC time: Fri 2021-11-26 09:13:24
                Time zone: Europe/Paris (CET, +0100)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

```
[daymoove@web www]$ sudo vi /etc/opt/remi/php74/php.ini
```

```
[daymoove@web www]$ cat /etc/opt/remi/php74/php.ini | grep timezone
[...]
date.timezone = "Europe/Paris"
```

### 3. Install NextCloud

**Récupérer Nextcloud**

```
[daymoove@web www]$ cd
```

```
[daymoove@web ~]$ curl -SLO https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  148M  100  148M    0     0  5138k      0  0:00:29  0:00:29 --:--:-- 5906k
```

```
[daymoove@web ~]$ ls
nextcloud-21.0.1.zip
```

**Ranger la chambre**
```
[daymoove@web ~]$ unzip nextcloud-21.0.1.zip
[...]
  inflating: nextcloud/COPYING
   creating: nextcloud/config/
 extracting: nextcloud/config/CAN_INSTALL
  inflating: nextcloud/config/config.sample.php
  inflating: nextcloud/config/.htaccess
```

```
sudo mv * /var/www/nextcloud/html/
```

```
[daymoove@web ~]$ rm nextcloud-21.0.1.zip
```

```
[daymoove@web ~]$ cd /var/www/nextcloud/
```

```
[daymoove@web html]$ sudo chown -R apache html/
```

```
[daymoove@web html]$ cd html/
```

```
[daymoove@web nextcloud]$ ls -al
total 128
drwxr-xr-x. 13 apache daymoove  4096 Apr  8  2021 .
drwxr-xr-x.  3 apache root        23 Nov 26 10:28 ..
drwxr-xr-x. 43 apache daymoove  4096 Apr  8  2021 3rdparty
drwxr-xr-x. 47 apache daymoove  4096 Apr  8  2021 apps
-rw-r--r--.  1 apache daymoove 17900 Apr  8  2021 AUTHORS
drwxr-xr-x.  2 apache daymoove    67 Apr  8  2021 config
-rw-r--r--.  1 apache daymoove  3900 Apr  8  2021 console.php
-rw-r--r--.  1 apache daymoove 34520 Apr  8  2021 COPYING
drwxr-xr-x. 22 apache daymoove  4096 Apr  8  2021 core
-rw-r--r--.  1 apache daymoove  5122 Apr  8  2021 cron.php
-rw-r--r--.  1 apache daymoove  2734 Apr  8  2021 .htaccess
-rw-r--r--.  1 apache daymoove   156 Apr  8  2021 index.html
-rw-r--r--.  1 apache daymoove  2960 Apr  8  2021 index.php
drwxr-xr-x.  6 apache daymoove   125 Apr  8  2021 lib
-rw-r--r--.  1 apache daymoove   283 Apr  8  2021 occ
drwxr-xr-x.  2 apache daymoove    23 Apr  8  2021 ocm-provider
drwxr-xr-x.  2 apache daymoove    55 Apr  8  2021 ocs
drwxr-xr-x.  2 apache daymoove    23 Apr  8  2021 ocs-provider
[...]
```

### 4. Test

**Modifiez le fichier hosts de votre PC**

Sur le PC sur git bash

```
$ cd C:/windows/system32/drivers/etc
```

```
$ nano hosts
```

```
$ cat hosts
[...]
# localhost name resolution is handled within DNS itself.
#       127.0.0.1       localhost
#       ::1             localhost
10.5.1.11 web.tp5.linux
```

**Tester l'accès à NextCloud et finaliser son install**

Sur un navigateur Web sur le PC :

http://web.tp5.linux

[Screen de nextcloud](./tp5pagenextcloud.PNG)

