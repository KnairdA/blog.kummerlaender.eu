# Informationen umformen mit XSL

Im Rahmen meiner Vorstandstätigkeit beim KV Konstanz der Piratenpartei betreue ich die Webseite [piraten-konstanz.de](http://piraten-konstanz.de)

Unsere Termine organisieren wir üblicherweise im [Wiki](http://wiki.piratenpartei.de/Kreisverband_Konstanz) - seit der Einführung der neuen KV Seite auf Basis von Wordpress müssen wir diese Termine doppelt pflegen. Da dies kein Zustand ist welcher mir auf Dauer gefällt, habe ich nach Möglichkeiten zum Auslesen der Terminliste im Wiki und dem anschließenden Darstellen in Wordpress gesucht.

Schlussendlich habe ich dann eine [XSLT](http://de.wikipedia.org/wiki/XSLT) geschrieben und rufe diese von einem einfachen [PHP-Script](http://piraten-konstanz.de/wp-content/tool/events_rss.php) auf.

Mit XSL lassen sich XML Dateien in andere Formen bringen. Da Mediawiki mehr oder weniger valides XHTML ausgibt, kann man, nachdem das XHTML mit [Tidy](http://tidy.sourceforge.net) ein wenig aufgeräumt wurde, sehr einfach die [Terminliste](http://wiki.piratenpartei.de/BW:Kreisverband_Konstanz/Termine) extrahieren und gleichzeitig in RSS umformen:

```xsl
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:x="http://www.w3.org/1999/xhtml"
 exclude-result-prefixes="x">
 
<xsl:import href="date-time.xsl"/>

<xsl:output method="xml"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="no" />

<xsl:template match="/">
	<rss version="2.0">
		<channel>
			<title>Termine des KV Konstanz</title>
			<link>http://wiki.piratenpartei.de/BW:Kreisverband_Konstanz/Termine</link>
			<description>Termine des KV Konstanz</description>
			<xsl:apply-templates/>
		</channel>
	</rss>
</xsl:template>

<xsl:template match="x:div[@id='pkn_main']/x:table/x:tr[position() &gt; 1]">
	<item>
		<title>
			<xsl:value-of select="x:td[3]"/>
			<xsl:text> am </xsl:text>
			<xsl:call-template name="format-date">
				<xsl:with-param name="date" select="x:td[1]/x:span/."/>
				<xsl:with-param name="format" select="'d.n.Y'"/>
			</xsl:call-template>
			<xsl:text> um </xsl:text>
			<xsl:value-of select="x:td[2]"/>
			<xsl:text> Uhr</xsl:text>
		</title>
		<link>
			<xsl:text>http://wiki.piratenpartei.de</xsl:text>
			<xsl:value-of select="x:td[3]/x:a/@href"/>
		</link>
	</item>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>
```

Der Kern dieses XSL ist nicht mehr als ein Template welches auf den [XPATH](http://de.wikipedia.org/wiki/XPATH) zum Finden der Terminliste reagiert. Die For-Each-Schleife iteriert dann durch die Termine und formt diese entsprechend in RSS um.  
Der einzige Knackpunkt kommt daher, dass XHTML kein normales XML ist und somit seinen eigenen Namespace hat. Diesen sollte man im Element `xsl:stylesheet` korrekt angeben, sonst funktioniert nichts. Auch muss im XPATH Ausdruck dann vor jedem Element ein `x:` eingefügt werden um dem XSL Prozessor den Namespace für das jeweilige Element mitzuteilen.

Das leere Template `xsl:template match="text()"` sorgt dafür, dass alle XML-Zweige, die nicht auf ein anderes Template passen, nicht ausgegeben werden.  
`xsl:template match="/"` springt auf das Root-Element der XHTML-Seite an, bildet die RSS Grundstruktur und bindet dann alle anderen Templates ein.

Zum Anpassen des Datums verwende ich - wie auch in diesem Blog - die [date-time.xsl](http://symphony-cms.com/download/xslt-utilities/view/20506/) Transformation.

## Generieren des RSS Feed

Mit der eben beschriebenen XSLT lässt sich jetzt in drei Schritten das fertige RSS generieren:

```sh
#!/bin/sh
wget -O termine_wiki.html "http://wiki.piratenpartei.de/BW:Kreisverband_Konstanz/Termine"
tidy -asxml -asxhtml -O termine_tidy.html termine_wiki.html
xsltproc --output termine_kvkn.rss --novalid termine_kvkn.xsl termine_tidy.html
```

In PHP ist das ganze dann zusammen mit sehr einfachem Caching auch direkt auf einem Webserver einsetzbar:

```php
define('CACHE_TIME', 6);
define('CACHE_FILE', 'rss.cache');

header("Content-Type: application/rss+xml");

if ( file_exists(CACHE_FILE) ) 
{
	if ( !filemtime(CACHE_FILE) < time() - CACHE_TIME * 3600 ) {
		readfile(CACHE_FILE);
	}
	else {
		if ( !generate_rss() ) {
			readfile(CACHE_FILE);
		}
	}
}
else {
	ob_start();	
	
	generate_rss();
	
	ob_end_flush(); 
	
	$cache_file = fopen(CACHE_FILE, 'w'); 
	fwrite($cache_file, ob_get_contents());
	fclose($cache_file); 
}
   
function generate_rss()
{
	$event_page =  file_get_contents('http://wiki.piratenpartei.de/BW:Kreisverband_Konstanz/Termine');

	if ($event_page != false)
	{
		$config = array('output-xhtml' => true, 'output-xml' => true);

		$tidy = new tidy();

		$xml = new DomDocument();
		$xml->loadXML( $tidy->repairString($event_page, $config) );

		$xsl = new DomDocument();
		$xsl->load('termine_kvkn.xsl');

		$xslt = new XsltProcessor();
		$xslt->importStylesheet($xsl);

		$rss = $xslt->transformToXML($xml);
		echo $rss;
		
		return true;
	}
	else {
		return false;
	}
}
```
