# SheevaPlug Überwachung

Um den Überblick über die Auslastung und den Traffic meines SheevaPlugs zu behalten setze ich [Conky](http://conky.sourceforge.net/), [dstat](http://freshmeat.net/projects/dstat/) und [gnuplot](http://www.gnuplot.info/) ein.

Den Systemmonitor Conky lasse ich mit dem Befehl `ssh -X -vv -Y -p 22 adrian@asterix "conky -c /home/adrian/.conkyrc"` über X-forwarding in meiner XFCE-Session anzeigen. Das klappt einwandfrei und ergibt zusammen mit dieser [Conky-Konfiguration](http://adrianktools.redirectme.net/files/.conkyrc) und einer lokalen Conky-Instanz folgendes Bild:

![Zwei Conky-Instanzen unter XFCE](http://static.kummerlaender.eu/media/remote_conky.jpg){: .full}

Zusätzlich loggt der SheevaPlug regelmäßig die aktuellen Systemdaten wie CPU-Auslastung, Netzwerkverkehr und belegten Arbeitsspeicher und generiert sie zu Graphen die mir dann jede Nacht per eMail zugesand werden.
Zum Loggen der Daten verwende ich dstat das mit folgendem, von einem Cron-Job gestarteten Befehl aufgerufen wird:

~~~
dstat -tcmn 2 1 | tail -1 >> /var/log/systat.log
~~~
{: .language-sh}

Die Argumente -tcmn geben hierbei die zu loggenden Systemdaten und deren Reihenfolge an – heraus kommen Zeilen wie diese:

	31-03 19:40:04 | 2 4 95 0 0 0 | 141M 11.3M 71.6M 277M | 684B 736B

Um 0 Uhr wird dann die Log-Datei von einem Cron-Job mit diesem Script wegkopiert, Graphen werden von gnuplot generiert und dann mit einem kleinen Python-Programm versendet.

~~~
#!/bin/sh
mv /var/log/systat.log /root/sys_graph/stat.dat
cd /root/sys_graph/
./generate_cpu.plot
./generate_memory.plot
./generate_network.plot
./send_report.py
~~~
{: .language-sh}

Hier das gnuplot-Script zur Erzeugung des CPU-Graphen als Beispiel:

~~~
#!/usr/bin/gnuplot
set terminal png
set output "cpu.png"
set title "CPU usage"
set xlabel "time"
set ylabel "percent"
set xdata time
set timefmt "%d-%m %H:%M:%S"
set format x "%H:%M"
plot "stat.dat" using 1:4 title "system" with lines, \
"stat.dat" using 1:3 title "user" with lines, \
"stat.dat" using 1:5 title "idle" with lines
~~~
{: .language-sh}

… und hier noch das Python-Programm zum Versenden per Mail:

~~~
#!/usr/bin/python2
import smtplib
from time import *
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart

lt = localtime()

# Mail-Header
msg = MIMEMultipart()
msg['Subject'] = strftime('Leistungsreport – %d%m%Y', lt)
msg['From'] = 'reports@asterix'
msg['To'] = 'mail@mail.mail'

msg.preamble = strftime('Leistungsreport – %d%m%Y', lt)

# Attachments
fileArray = ['cpu.png','memory.png','network.png']
for file in fileArray:
	fp = open(file, ‘rb’)
	img = MIMEImage(fp.read())
	fp.close()
	msg.attach(img)

# Login in SMTP-Server
s = smtplib.SMTP('smtpmail.t-online.de')
s.login('mail@mail.mail', '#####')

s.sendmail('mail@mail.mail', 'mail@mail.mail', msg.as_string())
s.quit()
~~~
{: .language-python}

Als Endergebniss erhalte ich dann täglich solche Grafiken per Mail:

![CPU Plot](http://static.kummerlaender.eu/media/cpu_plot.jpg){: .full .clear}

Ich finde es immer wieder erstaunlich mit wie wenigen Zeilen Quelltext man interessante Sachen unter Linux erzeugen kann – oder besser wie viel Programme wie gnuplot mit nur wenigen Anweisungen erzeugen können. So hat das komplette Schreiben dieser Scripts mit Recherche nur etwa 1,5 Stunden gedauert – inklusive Testen.  
Alle verwendeten Programme sind in den ArchLinux Paketquellen vorhanden – auch in denen von PlugBox-Linux, einer Portierung von ArchLinux auf ARM-Plattformen die ich nur immer wieder empfehlen kann – besonders nach den jetzt oft erscheinenden Paket-Updates. Aber dazu auch dieser Artikel: [Plugbox Linux – Ein ArchLinux Port für den SheevaPlug](/article/plugbox_linux_ein_archlinux_port_fuer_den_sheevaplug/).
