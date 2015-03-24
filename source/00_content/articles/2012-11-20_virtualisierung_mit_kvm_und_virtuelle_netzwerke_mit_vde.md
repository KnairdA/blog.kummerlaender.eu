# Virtualisierung mit KVM und virtuelle Netzwerke mit VDE

Ich spiele in meiner Freizeit gerne mit verschiedenen neuen Datenbank-Systemen, Sprachen und Frameworks - passe ich dabei nicht penibel auf, entsteht schnell ein Gewirr aus Konfigurations-Dateien und einmal installierten Paketen, die gar nicht mehr verwendet werden. Das System fühlt sich mit der Zeit also etwas ungut und zugemüllt an.

Bis jetzt versuche ich zumindest größere Entwicklungen in eigenen VMs abzugrenzen, ganz einheitlich bin ich dabei wegen einigen störenden Punkten aber nicht. Zum einen ist die Verwaltung der
Netzanbindung verschiedener VMs über die im Arch-Wiki [beschriebene Behelfsmethode](https://wiki.archlinux.org/index.php/KVM#Poor_Man.27s_Networking) mit SSH-Tunneln alles andere als schön, zum anderen will ich nicht für jede VM ein eigenes Fenster mit Konsole
rumfliegen haben. Was ich will, ist also eine "richtige" Netzwerk-Konfiguration über virtuelle Interfaces und einen Betrieb der VMs ohne grafische Oberfläche als Daemon im Hintergrund.

Als Virtualisierungs-System setze ich auf KVM, die Distribution der Wahl ist weiterhin ArchLinux.

## Kernel Based Virtual Machine

[KVM](http://www.linux-kvm.org/page/Main_Page) ist das direkt im Linux-Kernel integrierte Virtualisierung-System. Einzige Voraussetzung dafür ist ein Prozessor mit Virtualisierungs-Funktionen, diese sollten die meisten der in den
letzten Jahren auf den Markt gekommenen Prozessoren besitzen - selbst mein Core Duo aus 2007 führt KVM einwandfrei aus. Ansonsten verhält sich KVM identisch zu [QEMU](http://wiki.qemu.org/Main_Page), der einzige Unterschied ist,
dass der Prozessor nicht wie bei QEMU komplett emuliert wird, sondern die Befehle über den Kernel an den physikalischen Prozessor durchgereicht werden. Dies hat den Nachteil, dass KVM z.B.
keine ARM-Plattformen unter x86 ausführen kann, der große Vorteil ist jedoch die gute Performance. Es übertrifft bei mir - gefühlsmäßig, ich habe keine Benchmarks durchgeführt - ohne Probleme
sowohl [VirtualBox](https://wiki.archlinux.org/index.php/VirtualBox) als auch [VMware](https://wiki.archlinux.org/index.php/VMware).

Ein Vorteil aus der vollständigen Integration der KVM in den Kernel ist es, dass sich auch ganz normale Block-Geräte wie Festplatten-Partitionen etc. ohne Anpassung verwenden lassen.
Dadurch kann ich ohne Probleme z.B. ein auf einer zweiten Host-Partition installiertes Betriebssystem im laufenden Linux-Betrieb "dazubooten" und nutzen.

Angesteuert wird die KVM wahlweise über `qemu-kvm` oder `qemu --enable-kvm`. Damit das funktioniert müssen jedoch die Kernel-Module `kvm` und `kvm_intel` bzw. `kvm_amd` geladen werden.
Die grundlegende Verwendung abseits des anderen Befehls ist gleich wie bei QEMU. So werden Image-Dateien für die Gast-Systeme mit `qemu-img` erstellt und auch Einstellungen zur Hardware
des Gast-Systems werden auf die gleiche Weise gesetzt. Aus diesem Grund gehe ich hier auch nicht näher auf die grundlegende Verwendung ein, Details lassen sich bei Bedarf im Arch-Wiki [nachlesen](https://wiki.archlinux.org/index.php/QEMU).

Hier als Beispiel mein derzeitiger Standardaufruf von KVM, der für alle VMs gleich ist. Dynamisch ist allein das zu verwendende Speicher-Gerät - in meinem Fall verschiedene Image-Dateien.

~~~
qemu-kvm -cpu host -hda $1 -m 1024 -daemonize -vnc none -usb -net nic -net vde
~~~
{: .language-sh}

Dieser verwendet das als erster Parameter übergebene Gerät als Festplatte und setzt neben den nötigen Netzwerk-Einstellungen die VM mittels `-daemonize` in den Hintergrund. Falls benötigt, kann
als Wert des Parameters `-vnc` auch eine von einem Doppelpunkt angeführte Zahl übergeben werden um die Grafik-Ausgabe der VM an einen VNC-Server anzubinden (z.B. `-vnc :1` für `127.0.0.1:1`). Diese
Funktion verwende ich nicht, da ich ausschließlich über das interne Netzwerk die im Gast installierten Dienste nutze und administrative Tätigkeiten immer über SSH durchführe.

## Netzwerken mit VDE

[VDE](http://wiki.virtualsquare.org/wiki/index.php/VDE_Basic_Networking) steht für Virtual Distributed Ethernet und ermöglicht genau das was der Name erahnen lässt: Virtuelle Switches die beispielsweise VMs in einem Host internen LAN verbinden können.

Meine Konfiguration hält sich dabei im wesentlichen an den [Vorschlag](https://wiki.archlinux.org/index.php/QEMU#Networking_with_VDE2) im englischen Arch-Wiki, welchen ich in ein einfaches Script verpackt habe:

~~~
#!/bin/sh
case "$1" in
	start)
		ip tuntap add tap0 mode tap
		vde_switch -tap tap0 -daemon -pidfile .switch.pid -mod 660 -group kvm
		ip addr add dev tap0 192.168.100.254/24
		ip link set dev tap0 up
	;;
	stop)
		kill -9 `cat .switch.pid`
		rm .switch.pid
		ip tuntap del tap0 mode tap
	;;
esac
~~~
{: .language-sh}

Dieses Script erzeugt ein virtuelles Interface `tap0` und verbindet ein neues, als Daemon im Hintergrund laufendes, virtuelles Switch mit diesem. Als nächstes wird dann noch eine statische IP Konfiguration für das virtuelle Interface definiert. Durch diese können alle mit `-net nic -net vde` Parametern gestarteten KVM Gäste über die IP `192.168.100.254` auf den Host zugreifen.

In den Gast-Systemen selbst muss zusätzlich eine statische IP Konfiguration vorgenommen werden:

	interface=eth0
	address=192.168.100.1
	netmask=255.255.255.0
	broadcast=192.168.100.255
	gateway=192.168.100.254

Um das interne virtuelle LAN bei Bedarf mit der Außenwelt zu verbinden gibt es ebenfalls ein kleines Script welches die nötige Route erzeugt bzw. löscht:

~~~
#!/bin/sh
case "$1" in
	start)
		echo "1" > /proc/sys/net/ipv4/ip_forward
		iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o $2 -j MASQUERADE
	;;
	stop)
		iptables -t nat -X
		echo "0" > /proc/sys/net/ipv4/ip_forward
	;;
esac
~~~
{: .language-sh}

Anpassbar ist hierbei das Interface, um z.B. daheim `eth0` und unterwegs wahlweise `wlan0` oder `usb0` verwenden zu können.

## KVM Hardware Error

Nach einer Kernel Aktualisierung im ArchLinux Gast-System, kam es beim Neustart plötzlich zu dieser etwas erschreckenden Meldung:

	KVM: entry failed, hardware error 0x80000021
	
	If you're running a guest on an Intel machine without unrestricted mode
	support, the failure can be most likely due to the guest entering an invalid
	state for Intel VT. For example, the guest maybe running in big real mode
	which is not supported on less recent Intel processors.
	
	EAX=00000000 EBX=0020fa5c ECX=00000000 EDX=fffff000
	ESI=f6d29014 EDI=00000001 EBP=f6461fa0 ESP=f6461f60
	EIP=c0128443 EFL=00010246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
	ES =007b 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
	CS =0060 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
	SS =0068 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
	DS =007b 00000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
	FS =00d8 36648000 ffffffff 00809300 DPL=0 DS16 [-WA]
	GS =00e0 f6d2f540 00000018 00409100 DPL=0 DS   [--A]
	LDT=0000 ffff0000 f0000fff 00f0ff00 DPL=3 CS64 [CRA]
	TR =0080 f6d2d3c0 0000206b 00008b00 DPL=0 TSS32-busy
	GDT=     f6d28000 000000ff
	IDT=     c060b000 000007ff
	CR0=8005003b CR2=ffffffff CR3=006ef000 CR4=000006d0
	DR0=0000000000000000 DR1=0000000000000000 DR2=0000000700000000 DR3=0000000000000000 
	DR6=00000000ffff0ff0 DR7=0000000000000400
	EFER=0000000000000000
	Code=00 8b 15 c4 b5 61 c0 55 89 e5 5d 8d 84 10 00 c0 ff ff 8b 00 <c3> 8d b6 00 00 00 00 8d bf 00 00 00 00 8b 15 a0 ae 61 c0 55 89 e5 53 89 c3 b8 30 00 00 00

Dies sah für mich im ersten Moment wie ein klarer Hardware-Fehler aus, alle Informationen die sich über meine bevorzugte Suchmaschine finden ließen, waren jedoch für andere Situationen und ältere Kernel Versionen als `3.6.6-1`. Nach Tests mit verschiedenen Parametern für die zuständigen Kernel-Module, funktionierte es schließlich nach Laden des Moduls mit folgendem Befehl wieder einwandfrei:

~~~
modprobe kvm_intel emulate_invalid_guest_state=0
~~~
{: .language-sh}

Um den `emulate_invalid_guest_state` Parameter dauerhaft zu setzen reicht ein Eintrag in `/etc/modprobe.d`.

## Fazit

Mithilfe der beschriebenen Konfiguration und den Scripts lassen sich KVM VMs unsichtbar im Hintergrund starten und in einem Host-internen virtuellen LAN ansteuern. Bei Bedarf kann dieses virtuelle Netz mithilfe von Routen erweitert werden. Für den Netzzugriff in den Gast-Systemen reicht eine einfache statische Konfiguration.  
Ich werde das Ganze in nächster Zeit vermutlich noch etwas  erweitern und verbessern, aber diese Grundlage ist auf jeden Fall besser als die von mir am Anfang genutzten SSH-Tunnel zwischen Gast und Host. 

Das Erstellen einer neuen VM benötigt jetzt nicht viel mehr als eine Kopie eines Muster-Images und eine Anpassung der statischen IP Konfiguration - mit zusätzlichen Scripts könnte ich mir auch eine einfache, selbstgebaute Variante von [Vagrant](http://vagrantup.com/) auf KVM Basis vorstellen. Wobei auch dort, durch die [Einführung](https://github.com/mitchellh/vagrant/commit/391dc392675c73518ebf04252d824fe916e8860b) einer neuen Abstraktionsschicht, die Unterstützung von KVM als Alternative zu VirtualBox ein Stück näher gerückt sein dürfte.
