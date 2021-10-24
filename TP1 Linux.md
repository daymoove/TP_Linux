# TP Linux : Are you dead yet
**Joseph**
**SELVA**
**B1A**

**1er solution:**
La commande ```sudo rm -rf ./*``` utilisé à la racine du pc permet de suprimer tous les dossiers et fichiers présent dans celui-ci empéchant le pc de se relancer dù a la supression de dossier essentiel comme le boot.

**2eme solution:**
La commande ```sudo su -``` permet de passer en mode root et ainsi pouvoir avoir toute les permissions.Puis la commande ```cat /dev/urandom >/dev/sda``` permet d'ouvrir des datas random dans le disque dur ammenant rapidement la surcharge de celui-ci et donc la mort du pc.

**3eme solution:**
Après avoir fait la commande ```sudo su -``` pour se mettre en mode root, puis la commande```echo "toto" > /etc/shadow``` permet de remplacer tous les mots de passes de l'ordinateurs par toto empéchant ainsi le login des utilisateurs.

**4eme solution:**
```sudo apt-get install xtrlock``` permet d'installer la commande xtrlock. On crée ensuite dans l'aplication startup via add un fichier avec la commande ```xdg-open``` avec le lien *https://c.tenor.com/yheo1GGu3FwAAAAd/rick-roll-rick-ashley.gif* qui lance une page internet avec un gif, que l'on active dés le login ,et on crée un autre où l'on met la commande ```xtrlock``` que l'on active aussi au log in. Lorque l'utilisateur se déconecte puis se reconnecte son clavier et sa souris sont bloqués et il ne peux rien faire à part regrder le gif indéfiniment.

**5eme solution:**
On crée dans le dossier ```/etc``` un fichier nommer rc.local avec la commande ```nano rc.local```, dans lequelle on met ```#!/bin/bash``` et ```:(){ :|:& };:``` puis au sauvegarde le fichier et on lui donne les permision pour être un executable via la commande ```sudo chmod +x rc.local```. Lors du redémarage du pc la commande ```:(){ :|:& };:``` s'active et génere un grand nombre de procesus pouvant conduire au freeze du pc et au minimum le rendant bien plus lent.

**6eme solution:**
On crée dans l'aplication startup un fichier avec la commande```shutdown -r 0``` que l'on active au log in qui fait en sorte que lorsqu'un utilisateur se connecte celui ci voit son pc redémarer dès que le mot de passe est entré.

**7eme solution:**
En utilisant la commande ```chmod 000 /usr``` en mode root l'utilisateur se retrouve sans permision et se retrouve bloqué jusqu'au redémarage du pc qui ne se lance plus ne pouvant pas lancer le dossier usr.

**8eme solution:**
On crée un fichier executable en tant que root appelé rc.local dans lequel on met en premier ligne ```#!/bin/bash``` avec en suite une boucle infini créer par ```while true``` et la commande ```xdg-open``` avec le lien *https://c.tenor.com/ID04SPxfaIgAAAAd/wii-wii-dance.gif*. On ajoute ensuite dans l'aplication startup un chemin dans les commandes pour lancer cette executable en login et au démarage. Lors du login une infinité de page firefox avec des wii qui dance s'ouvre à l'infini pouvant entrainé le freeze du pc et au minimum le rendant inutilisable.

