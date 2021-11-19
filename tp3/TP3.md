# TP3 Linux : A little script

## I. Script carte d'identité

**Fichier Script** : [Idcard.sh](./idcard.sh)

sortie :
```bash
daymoove@daymoove-vm:/srv/idcard$ bash idcard.sh
Machine name : daymoove-vm
OS Ubuntu and kernel version is 5.11.0-38-generic
IP : 192.168.56.138
RAM : 1,3Gi RAM restante sur 1,9Gi RAM totale
Disque : 2,5G space left
Top 5 processes by RAM usage :
  - 3.6 /usr/lib/xorg/Xorg -core :0 -seat seat0 -auth /var/run/lightdm/root/:0 -nolisten tcp vt7 -novtswitch
  - 3.5 xfwm4 --replace
  - 2.2 Thunar --daemon
  - 1.7 xfdesktop
  - 1.7 /usr/bin/python3 /usr/bin/blueman-applet
Listening ports :
  - 53 : domain
  - 22 : ssh
  - 631 : ipp
  - 22 : ssh
  - 631 : ipp
Here's your random cat : https://cdn2.thecatapi.com/images/47k.jpg
```

## II Script youtube-dl

**Fichier script** : [yt.sh](./yt.sh)

**Fichier log** : [download.log](./download.log)

sortie :
```bash
daymoove@daymoove-vm:/srv/yt$ sudo bash yt.sh https://youtu.be/VsAe9W2-LBY
Video https://youtu.be/VsAe9W2-LBY was downloaded.
File path : /srv/yt/downloads/Me in online class #shorts/Me in online class #shorts.mp4
```

## III MAKE IT A SERVICE

**Fichier script** : [yt-v2.sh](./yt-v2.sh)

**Fichier service** : [yt.service](./yt.service)

On peut verifier le status su service avec la commande ```systemctl status yt.service```:

```
daymoove@daymoove-vm:/srv/yt$ systemctl status yt.service
● yt.service - Put Your video in the yt_dl file to download the video
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-11-19 12:54:30 CET; 6min ago
   Main PID: 48990 (bash)
      Tasks: 2 (limit: 2312)
     Memory: 1.3M
     CGroup: /system.slice/yt.service
             ├─48990 /usr/bin/bash /srv/yt/yt-v2.sh
             └─49235 sleep 30

nov. 19 12:54:30 daymoove-vm systemd[1]: Started Put Your video in the yt_dl file to download the video.
```

Les logs du service peuvent être observé avec la commande ```journalctl -xe -u yt```

```
daymoove@daymoove-vm:/srv/yt$ journalctl -xe -u yt
-- The job identifier is 19072 and the job result is done.
nov. 19 12:54:30 daymoove-vm systemd[1]: Started Put Your video in the yt_dl file to download the video.
-- Subject: A start job for unit yt.service has finished successfully
-- Defined-By: systemd
-- Support: http://www.ubuntu.com/support
--
-- A start job for unit yt.service has finished successfully.
--
-- The job identifier is 19274.
nov. 19 13:00:20 daymoove-vm bash[49217]: Video https://youtu.be/jNQXAC9IVRw was downloaded.
```

La commande ```daymoove@daymoove-vm:/srv/yt$ systemctl enable yt``` permet de lancer le service au démarage de la machine.