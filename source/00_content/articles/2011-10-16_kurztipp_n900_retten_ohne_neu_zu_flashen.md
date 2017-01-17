# Kurztipp: N900 retten ohne neu zu flashen

Letztens habe ich es beim herumexperimentieren mit dem [Speed- und Batterypatch](http://talk.maemo.org/showthread.php?t=73315) für das N900 geschafft einen endlosen Reboot zu erzeugen.  
Ich wusste, dass ich zum Korrigieren des Problems nur einen Wert in der Konfiguration des Batterypatch anpassen musste - konnte jedoch aufgrund des andauernden Neustartens nicht auf das rootfs zugreifen. 

Erst sah es so aus, als würde ich nicht darum herum kommen das Betriebsystem neu zu flashen und den Großteil meiner Einstellungen neu zu setzen, doch dann stieß ich auf das N900 [rescueOS](http://n900.quitesimple.org/rescueOS/).

Dabei handelt es sich um ein kleines Linux welches mithilfe des normalen [Flashers](http://tablets-dev.nokia.com/maemo-dev-env-downloads.php) direkt in den RAM des N900 kopiert und dort gebootet werden kann. Vom rescueOS aus kann man dann das Root-Dateisystem problemlos einbinden und Probleme beheben. Zum Starten reicht das [initrd Image](http://n900.quitesimple.org/rescueOS/rescueOS-1.0.img) und folgender Befehl:

```sh
flasher-3.5 -k 2.6.37 -n initrd.img -l -b"rootdelay root=/dev/ram0"
```

Nähere Informationen zur Verwendung und den Funktionen finden sich in der rescueOS [Dokumentation](http://n900.quitesimple.org/rescueOS/documentation.txt).
