# TP6 : Stockage et sauvegarde

## Partie 1 : Préparation de la machine backup.tp6.linux

### I. Ajout de disque

**Ajouter un disque dur de 5Go à la VM backup.tp6.linux**

```
[daymoove@backup ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
[...]
sdb           8:16   0    5G  0 disk
[...]
```

### II. Partitioning

**Partitionner le disque à l'aide de LVM**
```
[daymoove@backup ~]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
```

```
[daymoove@backup ~]$ sudo vgcreate backup /dev/sdb
  Volume group "backup" successfully created
```

```
[daymoove@backup ~]$ sudo lvcreate -l 100%FREE backup -n backup1
  Logical volume "backup1" created.
```

**Formater la partition**
```
[daymoove@backup ~]$ sudo mkfs -t ext4 /dev/backup/backup1
mke2fs 1.45.6 (20-Mar-2020)
Creating filesystem with 1309696 4k blocks and 327680 inodes
Filesystem UUID: b88a6882-9b2d-44c0-a0ec-53701b0ce0da
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736
[...]
```

**Monter la partition**
```
sudo mkdir /backup
```

```
sudo mount /dev/backup/backup1 /backup
```

```
[daymoove@backup /]$ df -h
[...]
/dev/mapper/backup-backup1  4.9G   20M  4.6G   1% /backup
```

```
[daymoove@backup /]$ sudo cat /etc/fstab
[...]
/dev/backup/backup1 /backup ext4 defaults 0 0
```

## Partie 2 : Setup du serveur NFS sur backup.tp6.linux

**Préparer les dossiers à partager**
```
[daymoove@backup ~]$ sudo mkdir /backup/web.tp6.linux
```

```
[daymoove@backup ~]$ sudo mkdir /backup/db.tp6.linux
```

```
[daymoove@backup backup]$ ls
db.tp6.linux  lost+found  web.tp6.linux
```

**Install du serveur NFS**
```
[daymoove@backup backup]$ sudo dnf install nfs-utils
[...]
Installed:
  gssproxy-0.8.0-19.el8.x86_64           keyutils-1.5.10-9.el8.x86_64        libverto-libevent-0.3.0-5.el8.x86_64
  nfs-utils-1:2.3.3-46.el8.x86_64        rpcbind-1.2.5-8.el8.x86_64

Complete!
```

**Conf du serveur NFS**
```
[daymoove@backup backup]$ sudo vi /etc/idmapd.conf
```

```
[daymoove@backup backup]$ cat /etc/idmapd.conf
[...]
Domain = tp6.linux
[...]
```

```
[daymoove@backup backup]$ sudo vi /etc/exports
```

```
[daymoove@backup backup]$ cat /etc/exports
/backup/web.tp6.linux/ 10.5.1.11/24(rw,no_root_squash)
/backup/db.tp6.linux/ 10.5.1.12/24(rw,no_root_squash)
```

rw = Le partage est en lecture écriture
no_root_squash = Le root de la machine où le répertoire est montée a des droits de root sur le repertoire


**Démarrez le service**
```
[daymoove@backup backup]$ sudo systemctl start nfs-server
```

```
[daymoove@backup backup]$ systemctl status nfs-server
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
   Active: active (exited) since Thu 2021-12-02 14:48:59 CET; 14s ago
  Process: 24545 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=exi>
  Process: 24533 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
  Process: 24532 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
 Main PID: 24545 (code=exited, status=0/SUCCES
[...]
```

```
[daymoove@backup backup]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
```

**Firewall**
```
[daymoove@backup backup]$ sudo firewall-cmd --add-port=2049/tcp --permanent
success
```

```
[daymoove@backup backup]$ sudo firewall-cmd --reload
success
```

```
[daymoove@backup backup]$ ss -lntr
[...]
LISTEN       0             64                         0.0.0.0:2049                     0.0.0.0:*
[...]


[daymoove@backup backup]$ ss -lptr
[...]
LISTEN      0           64                       0.0.0.0:rpc.nfs_acl                     0.0.0.0:*
[...]
```

## Partie 3 : Setup des clients NFS : web.tp6.linux et db.tp6.linux

**Install'**
```
[daymoove@web ~]$ sudo dnf install nfs-utils
[...]
Installed:
  gssproxy-0.8.0-19.el8.x86_64           keyutils-1.5.10-9.el8.x86_64        libverto-libevent-0.3.0-5.el8.x86_64
  nfs-utils-1:2.3.3-46.el8.x86_64        rpcbind-1.2.5-8.el8.x86_64

Complete!
```

**Conf'**
```
[daymoove@web /]$ sudo mkdir srv/backup
[daymoove@web srv]$ ls
backup
```

```
[daymoove@web srv]$ sudo vi /etc/idmapd.conf
```

```
[daymoove@web srv]$ cat /etc/idmapd.conf | grep Domain
Domain = tp6.linux
[...]
```

**Montage !**
```
[daymoove@web srv]$ sudo mount -t nfs 10.5.1.13:/backup/web.tp6.linux /srv/backup
```

```
[daymoove@web srv]$ df -h
10.5.1.13:/backup/web.tp6.linux  4.9G   20M  4.6G   1% /srv/backup
```

```
[daymoove@web srv]$ ls -al
[...]
drwxr-xr-x.  2 root root 4096 Dec  2 14:32 backup
```

```
[daymoove@web srv]$ sudo vi /etc/fstab
[daymoove@web srv]$ cat /etc/fstab
[...]
10.5.1.13:/backup/web.tp6.linux /srv/backup nfs defaults 0 0
```

```
[daymoove@web srv]$ sudo umount /srv/backup
```

```
[daymoove@web srv]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount.nfs: timeout set for Thu Dec  2 15:24:50 2021
mount.nfs: trying text-based options 'vers=4.2,addr=10.5.1.13,clientaddr=10.5.1.11'
/srv/backup              : successfully mounted
```

**Répétez les opérations sur db.tp6.linux**
```
[daymoove@db ~]$ sudo mount -t nfs 10.5.1.13:/backup/db.tp6.linux /srv/backup
```

```
[daymoove@db ~]$ df -h
10.5.1.13:/backup/db.tp6.linux  4.9G   20M  4.6G   1% /srv/backup
```

```
[daymoove@db ~]$ ls -al /srv
[...]
drwxr-xr-x.  2 root root 4096 Dec  2 14:32 backup
```

```
[daymoove@db ~]$ sudo umount /srv/backup
```

```
[daymoove@db ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount.nfs: timeout set for Thu Dec  2 15:50:34 2021
mount.nfs: trying text-based options 'vers=4.2,addr=10.5.1.13,clientaddr=10.5.1.12'
/srv/backup              : successfully mounted
```

## Partie 4 : Scripts de sauvegarde

### I. Sauvegarde Web


**Ecrire un script qui sauvegarde les données de NextCloud**
```
[daymoove@web backup]$ cat /srv/save/save.sh
#!/bin/bash
#save nextcloud directory
#daymoove
date_log=$(date "+%Y/%m/%d %T")
date_fichier=$(date "+%Y%m%d")
hours_fichier=$(date "+%H%M%S")
tar -czf /srv/backup/nextcloud_"$date_fichier"_"$hours_fichier".tar.gz /var/www/nextcloud/*
echo "["$date_log"] Backup /srv/backup/nextcloud_"$date_fichier"_"$hours_fichier".tar.gz created succesfully." >> "/var/log/backup/backup.log"

echo "Backup /srv/backup/nextcloud_"$date_fichier"_"$hours_fichier".tar.gz created succesfully."
```

```
[daymoove@web save]$ sudo bash save.sh
tar: Removing leading `/' from member names
Backup /srv/backup/nextcloud_20211206_153046.tar.gz created succesfully.
```

```
journalctl -xe
[...]
Dec 06 15:28:15 web.tp6.linux bash[2525]: Backup /srv/backup/nextcloud_20211206_152801.tar.gz created succesfully.
Dec 06 15:28:15 web.tp6.linux systemd[1]: backup.service: Succeeded.
[...]
```

**Créer un service**
```
[daymoove@web ~]$ cat /etc/systemd/system/backup.service
[Unit]
Description=Sauvegarde de nextcloud

[Service]
ExecStart=bash /srv/save/save.sh
Type=oneshot

[Install]
WantedBy=multi-user.target
```

```
[daymoove@web save]sudo systemctl start backup
```

**Vérifier que vous êtes capables de restaurer les données**
```
sudo tar -vxf /srv/backup/nextcloud_211205_100821.tar.gz -C /
[...]
var/www/nextcloud/html/data/daymoove/files/Photos/Library.jpg
var/www/nextcloud/html/data/daymoove/files/Photos/Birdie.jpg
var/www/nextcloud/html/data/daymoove/files/Photos/Toucan.jpg
var/www/nextcloud/html/data/daymoove/files/Photos/Vineyard.jpg
var/www/nextcloud/html/data/daymoove/files/Photos/Steps.jpg
var/www/nextcloud/html/data/daymoove/files/Photos/Readme.md
var/www/nextcloud/html/data/daymoove/files/Photos/Gorilla.jpg
```

**Créer un *timer**
```
[daymoove@web backup]$ sudo systemctl enable backup.timer
Created symlink /etc/systemd/system/timers.target.wants/backup.timer → /etc/systemd/system/backup.timer.
```

```
[daymoove@web backup]$ sudo systemctl list-timers
[...]
Mon 2021-12-06 16:00:00 CET  31min left n/a                          n/a         backup.timer                 backup.service
[...]
```

### II. Sauvegarde base de données

**Ecrire un script qui sauvegarde les données de la base de données MariaDB**
```
[daymoove@db srv]$ cat /srv/save/save.sh
#!/bin/bash
#save nextcloud directory
#daymoove
mysqldump -h localhost -p -u root nextcloud --password="toto" > super_dump.sql
date_log=$(date "+%Y/%m/%d %T")
date_fichier=$(date "+%Y%m%d")
hours_fichier=$(date "+%H%M%S")
tar -czf /srv/backup/nextcloud_db_"$date_fichier"_"$hours_fichier".tar.gz /srv/save/super_dump.sql
echo "["$date_log"] Backup /srv/backup/nextcloud_db_"$date_fichier"_"$hours_fichier".tar.gz created succesfully." >> "/var/log/backup/backup_db.log"
echo "Backup /srv/backup/nextcloud_db_"$date_fichier"_"$hours_fichier".tar.gz created succesfully."
rm super_dump.sql
```

**Créer un service**
```
[daymoove@db srv]$ cat /etc/systemd/system/backup_db.service
[Unit]
Description=Sauvegarde de la base de données

[Service]
ExecStart=bash /srv/save/save.sh
Type=oneshot

[Install]
WantedBy=multi-user.target
```

```
[daymoove@db save]$ sudo systemctl start backup_db
```

```
[daymoove@db backup]$ ls /srv/backup
nextcloud_db_20211206_162534.tar.gz
```

**Créer un timer**
```
[daymoove@db backup]$ cat /etc/systemd/system/backup.timer
[Unit]
Description=Lance backup_db.service à intervalles réguliers
Requires=backup_db.service

[Timer]
Unit=backup_db.service
OnCalendar=hourly

[Install]
WantedBy=timers.target
```

```
[daymoove@db backup]$ sudo systemctl enable backup.timer
Created symlink /etc/systemd/system/timers.target.wants/backup.timer → /etc/systemd/system/backup.timer.
```

```
[daymoove@db backup]$ sudo systemctl list-timers
NEXT                         LEFT       LAST                         PASSED    UNIT                         ACTIVATES
Mon 2021-12-06 17:00:00 CET  30min left n/a                          n/a       backup.timer                 backup_db.service
[...]
```

