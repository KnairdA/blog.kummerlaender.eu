# Notizen zu C++ und Unicode

Unicode ist ein Zeichensatz der den Großteil der weltweit gebräuchlichen Schriftsysteme abdeckt.
Jedes einzelne Symbol wird dabei von einem sogenannten Code-Point definiert, welcher bis zu 21 Bit umfassen kann.
Je nach präferierter Enkodierung wird ein solcher Code-Point von vier, zwei oder einer Code-Unit mit einer Länge von respektive ein, zwei oder vier Byte repräsentiert.

Die direkte Repräsentation eines Unicode Code-Points ohne Aufteilung auf mehrere Code-Units nennt sich UTF-32. Wird ein Code-Point in ein oder zwei jeweils zwei Byte langen Code-Units enkodiert, spricht man von UTF-16. Die in gewöhnlichen Anwendungsfällen effizienteste Enkodierung ist UTF-8. Dort wird jeder Code-Point von bis zu vier jeweils ein Byte langen Code-Units repräsentiert. Vorteil von UTF-8 gegenüber den beiden anderen Varianten ist dabei die Rückwärtskompatibilität zu ASCII sowie die Unabhängigkeit von der jeweils plattformspezifischen Byte-Reihenfolge. 

Getreu der auf [UTF-8 Everywhere](http://www.utf8everywhere.org/) hervorgebrachten Argumentation werden wir uns im Folgenden mit UTF-8 beschäftigen und die beiden alternativen Enkodierungsarten ignorieren.

Grundsätzlich stellt es auf der Plattform meiner Wahl - Linux mit Lokalen auf _en\_US.UTF-8_ - kein Problem dar, UTF-8 enkodierte Strings in C++ Programmen zu verarbeiten.
Den Klassen der C++ Standard Library ist es, solange wir nur über das reine Speichern und Bewegen von Strings sprechen, egal ob dieser in UTF-8, ASCII oder einem ganz anderen Zeichensatz kodiert ist. Möchten wir sicher gehen, dass ein in einer Instanz von _std::string_ enthaltener Text tatsächlich in UTF-8 enkodiert wird und dies nicht vom Zeichensatz der Quelldatei abhängig ist, reicht es dies durch voranstellen von _u8_ zu definieren:

	std::string test(u8"Hellø Uni¢ød€!");

Der C++ Standard garantiert uns, dass ein solcher String in UTF-8 enkodiert wird. Auch die Ausgabe von in dieser Form enkodierten Strings funktioniert nach meiner Erfahrung - z.T. erst nach setzen der Lokale mittels _std::setlocale_ - einwandfrei. Probleme gibt es dann, wenn wir den Text als solchen näher untersuchen oder sogar verändern wollen bzw. die Ein- und Ausgabe des Textes in anderen Formaten erfolgen soll. Für letzteres gibt es eigentlich die _std::codecvt_ Facetten, welche aber in der aktuellen Version der GNU libstdc++ noch [nicht implementiert](http://gcc.gnu.org/onlinedocs/libstdc++/manual/status.html#status.iso.2011) sind. 
Wir müssen in diesem Fall also auf externe Bibliotheken wie beispielweise [iconv](https://www.gnu.org/software/libiconv/) oder [ICU](http://site.icu-project.org/) zurückgreifen. Auch die in der C++ Standard Library enthaltenen Templates zur String-Verarbeitung helfen uns bei Multibyte-Enkodierungen, zu denen auch UTF-8 zählt, nicht viel, da diese mit dem _char_ Datentyp und nicht mit Code-Points arbeiten. So liefert _std::string_ beispielsweise für einen UTF-8 enkodierten String, welcher nicht nur von dem in einer Code-Unit abbildbaren ASCII-Subset Gebrauch macht, nicht die korrekte Zeichenanzahl. Auch eine String-Iteration ist mit den Standard-Klassen nur Byte- und nicht Code-Point-Weise umsetzbar. Wir stehen also vor der Entscheidung eine weitere externe Bibliothek zu verwenden oder Programm-Intern vollständig auf UTF-32 zu setzen.

### Ein UTF-8 Codepoint-Iterator in C++

Um zumindest für rein lesende Zugriffe auf UTF-8 Strings nicht gleich eine Bibliothek wie Boost oder [easl](http://code.google.com/p/easl/) verwenden zu müssen habe ich einen einfachen UTF-8 Codepoint-Iterator anhand der Spezifikation in [RFC3629](http://tools.ietf.org/html/rfc3629) implementiert. Den Quellcode dieser Klasse stelle ich auf [Github](https://github.com/KnairdA/CodepointIterator) oder in [cgit](http://code.kummerlaender.eu/CodepointIterator/tree/) als Open Source unter der MIT-Lizenz zur freien Verfügung.

UTF-8 enkodiert die aktuell maximal 21 Bit eines Unicode Code-Points in bis zu vier Code-Units mit einer Länge von je einem Byte. Die verbleibenden 
maximal 11 Bit werden dazu verwendet, Anfangs- und Fortsetzungs-Bytes eines Code-Points zu kennzeichnen und schon in der ersten Code-Unit zu definieren, in wie vielen Code-Units das aktuelle Symbol enkodiert ist.

<p>
<table>
	<thead>
		<tr>
			<th scope="col">Payload</th>
			<th scope="col">Struktur</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>7</td>
			<td><tt>0xxxxxxx</tt></td>
		</tr>
		<tr>
			<td>11</td>
			<td><tt>110xxxxx 10xxxxxx</tt></td>
		</tr>
		<tr>
			<td>17</td>
			<td><tt>1110xxxx 10xxxxxx 10xxxxxx</tt></td>
		</tr>
		<tr>
			<td>21</td>
			<td><tt>11110xxx 10xxxxxx 10xxxxxx 10xxxxxx</tt></td>
		</tr>
	</tbody>
</table>
</p>

In obenstehender Tabelle ist die in [RFC3629](http://tools.ietf.org/html/rfc3629) definierte Struktur der einzelnen Code-Units zusammen mit der jeweiligen Anzahl der Payload-Bits dargestellt.  
Anhand der Tabelle können wir erkennen, dass die Rückwärtskompatibilität zu ASCII dadurch gewährleistet wird, dass alle Code-Points bis 
einschließlich 127 im ersten Byte dargestellt werden können. Sobald in der ersten Code-Unit das Bit mit dem höchsten Stellenwert gesetzt ist, handelt es sich um einen Code-Point mit mehr als einer Code-Unit. Die genaue Anzahl der Code-Units lässt sich an der Anzahl der führenden 1er-Bits erkennen. Zwischen Payload und Header steht dabei immer ein 0er-Bit, Fortsetzungs-Bytes beginnen in UTF-8 immer mit dem Präfix <tt>10</tt>.

Zur Erkennung und Umformung der UTF-8 Code-Units verwenden wir in der _UTF8::CodepointIterator_-Klasse die folgenden, in stark typisierten Enums definierten, Bitmasken:

	enum class CodeUnitType : uint8_t {
		CONTINUATION = 128, // 10000000
		LEADING      = 64,  // 01000000
		THREE        = 32,  // 00100000
		FOUR         = 16,  // 00010000
	};

	enum class CodePoint : uint8_t {
		CONTINUATION = 63,  // 00111111
		TWO          = 31,  // 00011111
		THREE        = 15,  // 00001111
		FOUR         = 7,   // 00000111
	};

Bei tieferem Interesse lässt sich die Implementierung der UTF-8 Logik in der Quelldatei [codepoint_iterator.cc](https://github.com/KnairdA/CodepointIterator/blob/master/src/codepoint_iterator.cc) nachlesen.
Zusätzlich zu den in GoogleTest geschriebenen [Unit-Tests](https://github.com/KnairdA/CodepointIterator/blob/master/test.cc) sehen wir im folgenden noch ein einfaches Beispiel zur Verwendung des `UTF8::CodepointIterator` mit einem [Beispieltext](http://www.columbia.edu/~fdc/utf8/) in altnordischen Runen:

	std::string test(u8"ᛖᚴ ᚷᛖᛏ ᛖᛏᛁ ᚧ ᚷᛚᛖᚱ ᛘᚾ ᚦᛖᛋᛋ ᚨᚧ ᚡᛖ ᚱᚧᚨ ᛋᚨᚱ");

	for ( UTF8::CodepointIterator iter(test.cbegin());
		  iter != test.cend();
		  ++iter ) {
		std::wcout << static_cast<wchar_t>(*iter);
	}

Die Dereferenzierung einer Instanz des Iterators produziert den aktuellen Code-Point als _char32\_t_, da dieser Datentyp garantiert vier Byte lang ist. Die Ausgabe eines solchen UTF-32 enkodierten Code-Points ist mir allerdings leider nur nach dem Cast in _wchar\_t_ gelungen. Dieser wird trotzdem nicht als Dereferenzierungs-Typ verwendet, da die Länge nicht fest definiert ist, sondern abhängig von der jeweiligen C++ Implementierung unterschiedlich sein kann. Dies stellt jedoch kein größeres Problem dar, da der Iterator für die interne Betrachtung von Strings und nicht zur Konvertierung für die Ausgabe gedacht ist.

### Fazit

* UTF-8 ist die Kodierung der Wahl, da Übermenge von ASCII und kompakt für englische Texte
* Nicht alle Möglichkeiten die im Standard definiert sind, sind auch implementiert
* String-Manipulation und Konvertierung benötigten externe Bibliotheken
* Rein lesende Iteration durch UTF-8 enkodierte Strings ist mit relativ wenig Aufwand möglich
* Am wichtigsten ist es *eine* Kodierung zu verwenden und nur für I/O zu konvertieren
