# PlugBox Linux - Ein ArchLinux Port für den SheevaPlug

Nachdem ich ja jetzt einige Zeit Debian Lenny auf meinem SheevaPlug eingesetzt habe, verwende ich seit kurzem Plugbox Linux. [Plugbox](http://archlinuxarm.org/) ist eine Portierung von [ArchLinux](https://archlinux.de) auf den SheevaPlug und einige andere ARM-Hardware wie PogoPlug, Dockstar, GuruPlug und diverse Smartphones wie das N900.

Seit einiger Zeit läuft Arch also jetzt nicht mehr nur auf meinem Desktop sondern auch auf meinem Plug – und was soll ich sagen, ich bin einfach begeistert! 
Es läuft über längere Zeit zu meinem Erstaunen um einiges besser und stabiler als Debian. Ich habe bis jetzt keinerlei Probleme mehr mit MySQL CPU-Auslastung oder Zulaufen des Arbeitsspeichers. Ich kann den Plug jetzt tatsächlich über Monate ohne Reboot laufen lassen – bei Debian war ja leider öfter nötig. 

Nett ist es auch, dass ich mich nicht an neue Konfigurationsdateien gewöhnen und Pacman als Paketverwaltung verwenden kann. Auch die Installation von Paketen aus dem AUR wird unterstützt. Das war bei mir allerdings bis jetzt noch nicht nötig, da alles was ich zur Zeit brauche (Lighttpd, MySQL, php, python etc.) schon vorkompiliert in den Paketquellen vorhanden ist. Die Pakete werden übrigens nicht crosskompiliert o.ä. sondern werden direkt auf einem SheevaPlug erstellt.

## Installation

Installieren kann man das rootfs Image mit dem [SheevaPlug Installer 1.0](http://plugcomputer.org/data/docs/sheevaplug-installer-v1.0.tar.gz) sowohl im NAND des Plugs als auch auf einer SD Karte. Bei der Installation auf einer SD Karte musste ich für einen fehlerfreien Bootvorgang die Uboot bootcmd um ein zweites “mmcinit;” erweitern – ohne diese Anpassung blieb der Bootloader bei einem Kaltstart hängen.
