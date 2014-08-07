# Debian auf dem SheevaPlug

Auf dem herkömmlichen [Weg](http://www.cyrius.com/debian/kirkwood/sheevaplug/) ist es zwar möglich ein Debian auf dem SheevaPlug zu installieren, jedoch nur auf einem externen USB-Stick oder auf einer SD-Karte. Die Installation auf dem 512MB großen internen Flashspeicher des Plugs ist damit nicht möglich. Es gibt jedoch einen Weg um Debian auch im internen Speicher zu installieren, der auch noch um einiges komfortabler als der oben verlinkte Weg ist.

Als erstes laden wir uns den normalen SheevaInstaller herunter mit dem man Ubuntu 9.04 auf dem Sheeva installieren kann ([klick](http://www.plugcomputer.org/index.php/us/resources/downloads?func=select&id=5)). Nach dem wir den Tarball heruntergeladen haben sollte man ihn entpacken. Als nächstes laden wir ein Debian Lenny / Squeeze Prebuild von [hier](http://www.mediafire.com/sheeva-with-debian) herunter. Nun ersetzen wir die „rootfs.tar.gz“ mit der neuen Debian „rootfs.tar.gz“. Bevor wir jedoch mit der Installation beginnen müssen wir die neue „rootfs.tar.gz“ mit „tar“ entpacken. Dazu führen wir auf der Konsole

	mkdir rootfs
	cd rootfs
	tar xfvz rootfs.tar.gz

aus. In dem Ordner führen wir nun ein

	mknod -m 660 dev/ttyS0 c 4 64

aus. Mit diesem Befehl wird die fehlende serielle Konsole erstellt. Jetzt verpacken wir das Archiv wieder mit

	tar cfvz ../rootfs.tar.gz *

Den gesamten Inhalt des Ordners /install im SheevaInstaller-Verzeichniss müssen wir jetzt auf einen mit FAT formatierten USB-Stick kopieren. Diesen stecken wir schon einmal in den USB-Port des Sheevas. Als nächstes verbinden wir den SheevaPlug mit einem Mini-USB Kabel mit unserem Computer und führen das Script „runme.php“ aus. Wenn alles klappt wird nun ein neuer Boot-Loader und das rootfs auf den Plug kopiert. Dannach ist unser Debian einsatzbereit.
Sollte der Plug den USB-Stick nicht erkennen und somit auch das rootfs nicht kopieren können hilft es einen anderen USB-Stick zu verwenden. Beispielsweise wurde mein SanDisk U3 Stick trotz gelöschtem U3 nicht erkannt. Mit einem anderen Stick funktionierte es jedoch tadelos. Auch sollte der Stick partitioniert sein. Der Bootloader des SheevaPlugs kann nicht gut mit direkt auf dem Stick enthalten Dateisystemen umgehen. Wenn die MiniUSB Verbindung beim Ausführen des runme-Scripts nicht funktionieren sollte hilft oft ein

	rmmod ftdi_sio

und

	modprobe ftdi_sio vendor=0x9e88 product=0x9e8f

(beides als root). Ebenfalls sollte kein zweites Serielles-Gerät am Computer angeschlossen sein.  
Bei neueren Plugs kann man bei Problemen bei der Installation die Datei „uboot/openocd/config/interface/sheevaplug.cfg“ im SheevaInstaller-Ordner nach

	interface ft2232
	ft2232_layout sheevaplug
	ft2232_vid_pid 0×0403 0×6010
	#ft2232_vid_pid 0x9e88 0x9e8f
	#ft2232_device_desc “SheevaPlug JTAGKey FT2232D B”
	jtag_khz 2000

umändern.
Wenn Debian jetzt auf dem SheevaPlug läuft und man sich über SSH einloggen konnte (pwd: nosoup4u), sollte man als erstes ein Update machen.

	apt-get update && apt-get dist-upgrade

Über die Paketverwaltung kann man jetzt ganz einfach die benötigte Software installieren. Ich setzte auf meinem Plug z.B. lighttpd als Webserver mit PHP5 und MySQL für diese Website ein. Es empfielt sich /var und /tmp auszulagern um Löschzyklen zu sparen. Für /tmp eignet sich eine ramdisk.

### Erfahrungen

Ein Debian ist eine gute Alternative zu dem vorinstallierten Ubuntu 9.04. Denn dieses wirft Fehler bei booten aus und hat anfangs Konfigurationsprobleme. Auch braucht es im Vergleich zum Debian eine Ewigkeit zum booten. Das mag bei einem Server nicht wichtig sein, aber ich finde es dennoch schön schnell rebooten zu können. Das gute ist, dass man wenn man schon Erfahrung mit Ubuntu hat auch sehr gut mit Debian zurechtkommt. Aber Ubuntu Karmic lässt sich leider nicht mehr auf dem SheevaPlug installieren. Der SheevaPlug ist erstaunlich schnell. Er erstellt die Seiten etwa doppelt so schnell wie die Server des vorher von mir verwendeten Gratishoster “bplaced.net”. Auch hat er einen sehr geringen Stromverbrauch von nur 5 Watt. Und selbst wenn Webhostingangebote zumindest in der Internetanbindung schneller sein mögen, hat man mit einem SheevaPlug einen sehr günstigen Root-Server, auf dem man tun und lassen kann was man will.
