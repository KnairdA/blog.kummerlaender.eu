# Traffic-Überwachung mit vnstat

Heute möchte ich euch ein kleines und praktisches Programm zum Überwachen des Netzwerkverkehrs vorstellen: [vnstat](http://humdi.net/vnstat/).  
vnStat ist ein konsolenbasierter Netzwerkverkehrmonitor der Logs mit der Menge des Datenverkehrs auf beliebigen Netzwerkschnittstellen speichert. Aus diesen Logs generiert vnStat dann diverse Statistiken.

![vnStat](https://static.kummerlaender.eu/media/vnstat.jpg){: .full}

Installieren kann man vnstat unter Debian bequem aus den Paketquellen mit `apt-get install vnstat` oder unter ArchLinux mit `pacman -S vnstat`. Gestartet wird vnStat mit `vnstat`. Sobald der Daemon läuft schreibt vnstat den aktuellen Netzwerkverkehr in eine Datenbank. Durch Anhängen von Argumenten kann man jetzt schöne Statistiken auf der Konsole ausgeben, z.B. eine Statistik über die letzten Tage mit `vnstat -d` (siehe Bild) oder über die letzten Wochen mit `vnstat -w`. Eine Übersicht über alle möglichen Argumente bekommt man wie Üblich über `vnstat –help`. Eine sehr Interessante Funktion wie ich finde ist die Möglichkeit zur live-Anzeige des Verkehrs mit `vnstat -h`.

Ich finde vnStat zum Überwachen des Netzwerkverkehrs wirklich sehr praktisch, und auch das Anzeigen des Verkehrs über die letzen Tage, Wochen oder Monate ist nützlich. vnStat ist dabei sehr ressourcenschonend und verlangsamt das Netzwerk selbst nicht (es schaltet sich nicht etwa zwischen System und Netzwerkkarte). Für die Anzeige des Traffics auf einer schicken Internetseite gibt es auch das [vnStat PHP frontend](http://www.sqweek.com/sqweek/index.php?p=1). Weiterführende Informationen bekommt ihr auch auf der [Webpräsenz von vnStat](http://humdi.net/vnstat/).
