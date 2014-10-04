# Darstellen von GPS Daten mit gnuplot

Bei meiner letzten Wanderung in den Schweizer Alpen habe ich spaßeshalber das N900 alle 10 Sekunden meine Position loggen lassen. Als Ergebnis erhielt ich dann ein aus 1991 Messpunkten bestehendes XML entsprechend der GPX Spezifikation.

Die Daten der Messpunkte sind im XML als `trkpt`-Tags gespeichert. Enthalten sind jeweils der Längen- und Breitengrad, die Uhrzeit, der Modus (3d / 2d), die Höhe über Null und die Anzahl der zur Positionsbestimmung genutzten Satelliten. Aussehen tut das ganze dann z.B. so:

~~~
<trkpt lat="47.320591" lon="9.329439">
	<time>2011-06-12T07:57:39Z</time>
	<fix>3d</fix>
	<ele>870</ele>
	<sat>6</sat>
</trkpt>
~~~
{: .language-xml}

Diese Daten lassen sich nun sehr einfach Verarbeiten – ich habe das Python `xml.dom.minidom` Modul verwendet. Um die Positionen einfacher verwenden zu können, werden sie mit dieser Funktion in Listenform gebracht:

~~~
def getPositions(xml):
	doc = minidom.parse(xml)
	node = doc.documentElement
	rawTrkPt = doc.getElementsByTagName("trkpt")
	positions = []
	for TrkPt in rawTrkPt:
		pos = {}
		pos["lat"] = TrkPt.getAttribute("lat")
		pos["lon"] = TrkPt.getAttribute("lon")
		pos["ele"] = int(TrkPt.getElementsByTagName("ele")[0].childNodes[0].nodeValue)
		positions.append(pos)
	return positions
~~~
{: .language-python}

Aus dieser Liste kann ich jetzt schon einige Kennzahlen ziehen:

~~~
def printStats(gpxPositions):
	highEle = gpxPositions[0]["ele"]
	lowEle = gpxPositions[0]["ele"]
	for pos in gpxPositions:
		if pos["ele"] > highEle:
			highEle = pos["ele"]
		if pos["ele"] < lowEle:
			lowEle = pos["ele"]
	eleDiv = highEle - lowEle
	print "Measure points: " + str(len(gpxPositions))
	print "Lowest elevation: " + str(lowEle)
	print "Highest elevation: " + str(highEle)
	print "Height difference: " + str(eleDiv)
~~~
{: .language-python}


Die Kennzahlen für meine Testdaten wären:

	Measure points: 1991
	Lowest elevation: 863
	Highest elevation: 1665
	Height difference: 802

Da die Daten ja, wie schon im Titel angekündigt, mit gnuplot dargestellt werden sollen werden sie mit dieser Funktion in für gnuplot lesbares CSV gebracht:

~~~
def printCsv(gpxPositions):
	separator = ';'
	for pos in gpxPositions:
		print pos["lat"] + separator + pos["lon"] + separator + str(pos["ele"])
~~~
{: .language-python}

## Plotten mit gnuplot

![Gnuplot output](http://static.kummerlaender.eu/media/gnuplot_gpx.jpg){: .full .clear}

Eine solche, dreidimensionale Ausgabe der GPS Daten zu erzeugen ist mit der `splot`-Funktion sehr einfach.

~~~
#!/usr/bin/gnuplot
set terminal png size 1280,1024
set output "output.png"
set multiplot
set yrange [9.365:9.31]
set xrange [47.325:47.28]
set zrange [800:1700]
set view 28,272,1,1
set ticslevel 0
set grid
set datafile separator ';'
splot "/home/adrian/projects/gpxplot/wanderung_120611.csv" with impulses lt 3 lw 1
splot "/home/adrian/projects/gpxplot/wanderung_120611.csv" with lines lw 2
unset multiplot
~~~
{: .language-sh}

Mit `set terminal png size 1280,1024` und `set output "output.png"` werden zuerst das Ausgabemedium, die Größe und der Dateiname der Ausgabe definiert. Dannach aktiviert `set multiplot` den gnuplot-Modus, bei dem mehrere Plots in einer Ausgabe angezeigt werden können. Dieses Verhalten brauchen wir hier, um sowohl die Strecke selbst als rote Line, als auch die zur Verdeutlichung verwendeten blauen Linien gleichzeitig anzuzeigen.
Mit `set [y,x,z]range` werden die Außengrenzen des zu plottenden Bereichs gesetzt. Dies ließe sich natürlich auch über ein Script automatisch erledigen. Als Nächstes wird mit `set view 28,272,1,1` die Blickrichtung und Skalierung definiert. `set ticslevel 0` sorgt dafür, dass die Z-Achse direkt auf der Grundebene beginnt. Um ein Gitter auf der Grundfläche anzuzeigen, gibt es `set grid`.  
Als letztes werden jetzt die zwei Plots mit `splot` gezeichnet. Die Angaben hinter `with` steuern hierbei das Aussehen der Linien.

Falls jemand den Artikel mit meinen Daten nachvollziehen möchte - das GPX-File kann hier heruntergeladen werden: 
 [2011-06-12.gpx](http://static.kummerlaender.eu/media/2011-06-12.gpx)

Zum Schluss hier noch ein Blick vom Weg auf den Kronberg Richtung Jakobsbad im Appenzell:

![Aussicht auf Jakobsbad im Appenzell](http://static.kummerlaender.eu/media/kronberg.jpg){: .full}
