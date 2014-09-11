# Erfahrungen mit einer SSD unter Linux

Seit wenigen Tagen setze ich nun eine SSD ([Intel SSD 330 @ 120GiB](http://ark.intel.com/products/67287/Intel-SSD-330-Series-(120GB-SATA-6Gbs-25nm-MLC))) in meinem t60p ein. Kurz zusammengefasst: Ich bin begeistert.
Im folgenden möchte ich noch ein wenig auf die von mir an der ArchLinux-Installation vorgenommenen Anpassungen eingehen.

Erstmals habe ich den Datenträger nicht mehr mit der üblichen MBR-Partitionstabelle ausgestattet sondern die modernere ["GUID Partition Table"](https://wiki.archlinux.org/index.php/GPT), 
kurz GPT, verwendet. GPT entstammt der UEFI-Spezifikation und schafft nicht nur eine klarere Kennzeichnung der Partitionen über GUIDs, sondern ermöglicht auch über 128 Partitionen. Nicht, 
dass ich diese bräuchte, aber man erkennt deutlich das eine GPT um einiges mächtiger und zeitgemäßer als eine MBR-Partitionstabelle ist. 

Auf der 120 GiB fassenden SSD habe ich eine 4 GiB große Swap-Partition angelegt, die ich ausschließlich für den Hibernate-Modus verwenden möchte. Die mit ext4-formatierte Root-Partition
ist auf 96 GiB festgesetzt um noch ein wenig zusätzlichen Platz für das Wear-Leveling des SSD-Controllers zu Verfügung zu stellen.

Beim Bootloader setze ich erstmals in meiner Linux-Geschichte auf einem normalen Rechner nicht mehr GRUB, sondern [Syslinux](https://wiki.archlinux.org/index.php/Syslinux) ein, was aber keinen bestimmten Grund außer Neugierde hat.

Die Installation lief ansonsten weitgehend normal ab. Die einzigen SSD spezifischen Anpassungen sind die Aktivierung der [TRIM-Funktion](http://en.wikipedia.org/wiki/TRIM) über das `discard` Mountflag,
die Reduzierung des ext4-Journaling mittels dem `data=ordered` Mountflag und das Heraufsetzen der Swappiness auf 1 um die Auslagerungspartition ausschließlich in Notfällen und für den Hibernate-Modus
zu verwenden. An Software setze ich den ["Profile-Sync-Daemon"](https://wiki.archlinux.org/index.php/Profile-sync-daemon) und den ["Anything-Sync-Daemon"](https://wiki.archlinux.org/index.php/Anything-sync-daemon) 
zum Auslagern der Browser-Profile und `/var/log/` in den Arbeitsspeicher ein.
Dies soll dazu dienen, die Schreibvorgänge auf den Speicherzellen etwas zu reduzieren und damit hoffentlich die Haltbarkeit der SSD etwas zu erhöhen - wenn das bei den heutigen Modellen nicht mehr
nötig sein sollte ist das umso besser. Die 16 GiB SD-Karte des SheevaPlugs läuft ja nun auch schon zwei Jahre ohne Probleme zu zeigen.

Hier meine derzeitige `/etc/fstab`:

~~~
# 
# /etc/fstab: static file system information
#
# <file system>	<dir>	<type>	<options>	<dump>	<pass>
tmpfs	/tmp	tmpfs	nodev,nosuid	0	0

/dev/sda1	swap	swap	defaults,noatime,discard	0 0
/dev/sda2	/		ext4	defaults,noatime,discard,data=ordered	0 0
~~~
{: .language-sh}

## Verschlüsselung?

Eigentlich bin ich was Daten angeht sehr paranoid - meine relevanten Speichermedien sind alle vollverschlüsselt, dass gilt auch für die Betriebsystem-Partitionen. Ich achte sehr darauf,
dass keinerlei eigentlich verschlüsselte Daten in unverschlüsselte Gefilde "ausbrechen"... für die SSD muss ich vorerst auf einen Teil davon verzichten.  
Das liegt daran, dass der im 2007er Thinkpad verbaute Core-Duo nur etwa 30 MiB/s unter LUKS ver- bzw. entschlüsselt. Auf einer herkömmlichen Platte konnte ich das noch verkraften, eine SSD ist mir dafür aber eindeutig zu schade. Um nicht alles entschlüsseln zu müssen und meine schützenswürdigen Daten weiterhin sicher zu lagern, werde ich mir voraussichtlich einen UltraBay-Adapter zulegen und
das sowieso nur noch selten genutzte DVD-Laufwerk mit einer herkömmlichen Festplatte ersetzen.   
Dank hdparm kann diese ja in einen Ruhemodus versetzt werden und muss so nicht die ganze Zeit laufen. Ein weiterer Vorteil der SSD, namentlich Stille dank der Abstinenz beweglicher Teile, wird also zumindest nicht ganz verloren gehen. 

Die komplette Verschlüsselung der SSD wird jedoch erst nach einem deutlich größeren Hardwareupgrade wieder Sinn machen. So schaffen aktuelle Prozessoren dank des [AES-NI](http://en.wikipedia.org/wiki/AES_instruction_set) Befehlssatzes hunderte MB pro Sekunde Durchsatz, dieser ist dann auch für eine SSD wieder groß genug. 

## Fazit

Alles in allem bin ich mit meinem Umstieg trotz der nötigen Abstriche sehr zurieden und möchte nicht mehr auf ein System ohne SSD zurück. Denen, die sich näher mit dem Thema auseinandersetzen wollen, empfehle ich die entsprechende Seite im englischen Arch-Wiki: [SSD](https://wiki.archlinux.org/index.php/SSD) und zur Kaufberatung die Tests auf [StorageReview.com](http://www.storagereview.com/).
