# Tarsnap - Backups für Paranoide

Für meine Backups nutze ich jetzt seit einiger Zeit den Online-Service [Tarsnap](http://www.tarsnap.com/). Dabei handelt es sich um einen Client der es ermöglicht verschlüsselte Backups in der Amazon-Cloud zu speichern und zu verwalten.

Das ganze ist so aufgebaut, dass immer nur veränderte und neue Dateien übertragen werden müssen. Alle Daten werden schon vom Client verschlüsselt, sodass keine unverschlüsselten Daten übers Netzwerk fließen und weder die Entwickler von Tarsnap noch Amazon den Inhalt der Daten auslesen können.

Der Service ist nicht kostenlos, aber sehr günstig - der Preis pro Byte Speicher / Datenverkehr beträgt 300 Picodollar, ein Gigabyte kostet also pro Monat nur 0,30 Dollar.

Der Tarsnap-Client ist im Quellcode verfügbar (aber nicht unter einer Open Source Lizenz) und lässt sich problemlos auch auf ARM Prozessoren kompilieren, sodass ich auch vom N900 und SheevaPlug aus Zugriff auf meine Backups haben kann. Die Authentifizierung mit dem Server funktioniert über einen Schlüssel, der sich nach Eingabe des Passworts mit folgendem Befehl generieren lässt:

```sh
tarsnap-keygen --keyfile [pfad-zum-schlüssel] --user [email] --machine [hostname]
```

Die resultierende Datei ermöglicht ohne zusätzliche Authentifizierung Zugriff auf die Backups und sollte somit sicher aufbewahrt werden und nicht in falsche Hände geraten, denn ohne sie hat man keinen Zugriff mehr auf seine Daten.

Ein neues Backup lässt sich über diesen Befehl anlegen:

```sh
tarsnap -c -f [name-des-backups] [zu-sichernder-pfad]
```

Jedes weitere Backup geht danach um einiges schneller weil Tarsnap nur veränderte Daten überträgt. Standardmäßig wird dieser Cache unter "/usr/local/tarsnap-cache" und der Schlüssel unter "/root/tarsnap.key" erwartet, dies lässt sich jedoch über entsprechende Parameter steuern - näheres dazu findet sich auf der [Manpage](http://www.tarsnap.com/man-tarsnap.1.html).

Sollte man dann einmal in die nicht wünschenswerte Situation kommen Zugriff auf sein Backup zu benötigen, reicht dieser Befehl um die Daten wiederherzustellen:

```sh
tarsnap -x -f [name-des-backups] [wiederherzustellender-pfad]
```

Tarsnap kann ich wirklich empfehlen, es hat mich vom [Konzept](http://www.tarsnap.com/design.html) und der Umsetzung her voll überzeugt und ist auf jeden Fall eine ernst zunehmende Alternative zu anderen Backuplösungen in der _Wolke_. 

Der Tarsnap Client ist direkt aus den ArchLinux Repositories verfügbar: [tarsnap](http://www.archlinux.org/packages/community/i686/tarsnap/)

