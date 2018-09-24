# Visualisierung von Metriken in Voronoi-Diagrammen

In der Analysis 2 Vorlesung meines Mathematik Studiums beschäftigen wir uns derzeit mit Normen und Metriken in endlich dimensionalen Vektorräumen, welche wiederum die Grundlage für die Übertragung der, aus Analysis 1 bekannten, Konvergenz und Stetigkeitsbegriffe in höhere Dimensionen schaffen. Während der Bearbeitung der entsprechenden Übungsblätter habe ich dabei nach Visualisierungsmöglichkeiten recherchiert, um eine bessere Intuition für diese Begriffe zu erlangen. Voronoi-Diagramme sind eine solche Möglichkeit, deren Grundlagen und Generierung ich in diesem Artikel zwischen Theorie und Praxis näher erläutern möchte.

## Normen und Metriken in endlichdimensionalen Vektorräumen

In der herkömmlichen Schulmathematik sowie alltäglichen Rechnungen definieren wir Begriffe wie die Größe einer Zahl und den Abstand zwischen zwei Zahlen implizit über deren Betrag beziehungsweise die Differenz $\vert a-b \vert$ mit $a, b \in \mathbb{R}$ [^1]. Diese implizite, ja _intuitive_ Definition der genannten Begriffe reicht für vieles aus, gelangt aber schnell an ihre Grenzen, wenn wir das Ganze, im Rahmen der mathematischen Arbeit des Beweisens, auf formale Grundlagen stellen und als Fundament für Aussagen in anderen Mengen als den herkömmlichen Zahlen nutzen wollen.

Mit nicht herkömmlichen Zahlen meine ich dabei Elemente aus Vektorräumen[^2] wie $\mathbb{R}^2$. Zumindest für diesen, mittels eines Kartesischen Koordinatensystems als zweidimensionale Ebene darstellbaren, Vektorraum, haben wir in der Schule eine Vorstellung bekommen. Dies trifft sich gut, da sich auch die Visualisierung von Metriken mittels Voronoi-Diagrammen in diesem Raum abspielen wird.

Betrachten wir zunächst den Begriff der Größe oder auch des Betrags einer Zahl. Dieser wird für Elemente eines Vektorraums, also Vektoren, über Normen beschrieben. Eine Norm ist dabei formal eine Abbildung $\| \cdot \| : V \rightarrow \mathbb{R}_{\geq0}$, also eine Funktion, die Elementen aus einem $\mathbb{K}$-Vektorraum $V$[^3] einen reellen Wert größer oder gleich Null zuordnet.  
Diese Funktion darf dabei nicht vollkommen beliebig definiert sein, sondern muss für $x, y \in V$ sowie $\alpha \in \mathbb{K}$ die folgenden Bedingungen erfüllen:

------------------- -------------------------------
Definitheit         $\|x\|=0 \Leftrightarrow x=0$  
Homogenität         $\|\alpha * x\|=\alpha * \|x\|$
Dreiecksungleichung $\|x+y\| \leq \|x\| + \|y\|$
------------------- -------------------------------

Diese Anforderungen bedeuten, dass eine Funktion genau dann als Norm gesehen werden kann, wenn sie nur den Nullvektor auf die reelle Null abbildet, Skalare analog zu linearen Ausrücken _herausgezogen_ werden können und ein Umweg zwischen zwei Punkten nie kürzer ist, als der direkte Verbindungsweg.

Betrachten wir an dieser Stelle die Defintion der häufig verwendeten Klasse der p-Normen:

$$\|x\|_p := \left(\displaystyle\sum_{i=1}^{n} \vert x_i \vert ^p\right)^\frac{1}{p} \; \text{mit} \; x \in \mathbb{R}^n ,\; p \in \mathbb{R_{\geq1}}$$

Beachtenswerter Weise geht aus dieser Norm für $p=1$ die Betragsnorm, also die Aufsummierung aller Komponentenbeträge des gegebenen Vektors, sowie für $p=2$ die sogenannte Euklidische Norm hervor. Durch Verschieben von $p$ im Intervall $[1, \infty]$ lässt sich dabei die charakteristische Rautenform der Einheitskugel[^4] der Betragsnorm über die tatsächlich kugelförmige Einheitskugel der Euklidischen Norm in die quadratische Form der Maximumsnorm überführen ($p \rightarrow \infty$).

![Veränderung der abgeschlossenen Einheitskugel unter der p-Norm für p zwischen 1 und 3](https://static.kummerlaender.eu/media/unit_circle_cycle.gif)

Kommen wir nun zum Begriff des Abstands zwischen zwei Zahlen, welcher in Form von Metriken auf algebraische Strukturen wie Vektorräume übertragen wird. Wie in der Einführung dieses Abschnits beschrieben, haben wir den Abstand zwischen Zahlen schon in der Schule über den Betrag der Differenz beschrieben. Wir kennen an dieser Stelle in Form des Satz des Pythagoras auch schon eine sinnvolle Definition für den Abstand zwischen Punkten in $\mathbb{R}^2$:

$$d(x,y) := \sqrt{\vert x_1-x_2 \vert ^2 - \vert y_1-y_2 \vert ^2} \; \text{mit} \; x, y \in \mathbb{R}^2$$

Diese Metrik über dem zweidimensionalen reellen Vektorraum lässt sich, auf folgende naheliegende Art und Weise, in eine Metrik für alle endlich dimensionalen $\mathbb{R}$-Vektorräume erweitern:

$$d(x,y) := \sqrt{\displaystyle\sum_{i=1}^{n} \vert x_i - y_i \vert ^2} \; \text{mit} \; x, y \in \mathbb{R}^n$$

Diese Metrik auf Grundlage des Satz des Pythagoras wird als Euklidische Metrik bezeichnet. Sie ist eine der Metriken, welche wir im weiteren Verlauf dieses Artikels in Voronoi-Diagrammen visualisieren werden.

Die Definition solcher Metriken als Abbildungen der Form $d(x,y) : V \times V \rightarrow \mathbb{R}_{\geq0}$ beinhaltet eine Menge von Axiomen, welche von der Metrik-Abbildung erfüllt sein müssen.

-------------------- --------------------------------------------------
Positive Definitheit $d(x,y) \geq 0 \land d(x,y)=0 \Leftrightarrow x=y$
Symmetrie            $d(x,y) = d(y,x)$
Dreiecksungleichung  $d(x,z) \leq d(x,y) + d(y,z)$
-------------------- --------------------------------------------------

Wir fordern also, dass der Abstand zwischen beliebigen Punkten immer größer gleich Null sein muss, ein Nullabstand äquivalent zur Gleichheit der Punkte ist, die Reihenfolge der Punkte für den Abstand irrelevant ist und das der direkte Abstand zwischen zwei Punkten kleiner gleich einem Umweg über weitere Punkte ist.

Bei der Betrachtung der Definitionen von p-Norm und Euklidischer Metrik fällt auf, dass diese sich zu ähneln scheinen. Dies ist kein Zufall, denn Metriken können aus Normen _induziert_ werden. So folgt die Euklidische Metrik mit $d(x,y) := \|x-y\|_2$ direkt aus der 2-Norm.

Es liegt also Nahe, dass auch aus die Betragsnorm mit $p=1$ eine Metrik induziert - die sogenannte Mannheimer-Metrik:

$$d(x,y) := \displaystyle\sum_{i=1}^{n} \vert x_i - y_i \vert \; \text{mit} \; x, y \in \mathbb{R}^n$$

Die Bezeichnung dieser Metrik als Mannheimer-, Manhattan oder auch Taxi-Metrik wird nachvollziehbar, wenn wir uns bewusst machen, dass sie die Betragsdifferenzen der Punkte aufsummiert und somit den Weg beschreibt, den ein Taxi in einem Straßenraster nachvollziehen müsste, wie es in Mannheim und zahlreichen nordamerikanischen Städten üblich ist, um von A nach B zu gelangen.

Wir haben also nun zwei Metriken kennengelernt, die beide für verschiedene $p$ aus der gleichen p-Norm hervorgehen. Die Mathematik charakterisierende Suche nach gemeinsamen Mustern in abstrakten Strukturen legt nahe, dass so, wie die Betragsnorm und die Euklidische Norm Varianten der allgemeineren Klasse der p-Normen sind, auch die Mannheimer und Euklidische Metrik Varianten einer allgemeineren Klasse von Metriken sind. Diese allgemeinere Klasse beschreiben wir in Form der Minkowski-Metrik:

$$d(x,y) := \left(\displaystyle\sum_{i=1}^{n} \vert x_i - y_i \vert ^p\right)^\frac{1}{p} \; \text{mit} \; x, y \in \mathbb{R}^n ,\; p \in \mathbb{R_+}$$

Die Beschreibung der Euklidischen und Mannheimer-Metrik als Varianten der Minkowski-Metrik ist damit gerechtfertigt, dass diese für $p=1$ beziehungsweise $p=2$ aus ihr hervorgehen.

Besonders interessant ist im Kontext der Visualisierung von Metriken, dass die Minkowski-Metrik für $p \in [1, 2]$ einen stetigen Übergang von der Mannheimer in die Euklidische Metrik ermöglicht. Dies ergibt schöne, _flüssige_ Voronoi-Diagramme, wie wir im Abschnitt zu bewegten Bildern sehen werden.

[^1]: $\mathbb{R}$ könnte an dieser Stelle auch die Menge $\mathbb{N}$ der natürlichen Zahlen, die Menge $\mathbb{C}$ der komplexen Zahlen oder ein beliebiger anderer Körper sein, für den der Betrag definiert ist.
[^2]: Ein Vektorraum ist eine Menge von Vektoren gleicher Dimension, für welche die Operationen der Vektoraddition und Skalarmultiplikation sinnvoll definiert sind. Eine sinnvolle Definition dieser Operationen schließt neben einigen Rechenregeln mit ein, dass ein unter der Addition neutrales Element, der Nullvektor, sowie ein unter der Skalarmultiplikation neutraler Skalar, das Einselement, existieren. Zusätzlich muss zu jedem Vektor ein bezüglich der Addition inverses Element existieren, d.h. ein $v \in V$ mit $v + -v = 0$. Zusammenfassend führen diese Anforderungen dazu, dass innerhalb eines Vektorraums in weitgehend gewohnter Art und Weise gerechnet werden kann.
[^3]: Der Begriff $\mathbb{K}$-Vektorraum sagt aus, dass alle Komponenten der enthaltenen Vektoren Elemente aus dem Körper $\mathbb{K}$ sind. Im Falle eines $\mathbb{R}$-Vektorraums sind also beispielsweise alle Komponenten aller Vektoren reelle Zahlen. Der Körper ist dabei auch die Menge, aus der die Skalare für die Skalarmultiplikation gegriffen werden.
[^4]: Die abgeschlossene Einheitskugel ist die Menge $\overline{B}(1,0) := \{x \in V \vert \|x\| \leq 1 \}$ - also die Menge aller Vektoren mit Länge kleiner gleich Eins. Die Visualisierung dieser Kugel kann zur Charakterisierung von Normen herangezogen werden.

## Voronoi-Diagramme

Nachdem wir uns im vorangehenden Abschnitt einen groben Überblick über Normen und Metriken in endlich dimensionalen reellen Vektorräumen gemacht haben, können wir uns nun dem eigentlichen Thema dieses Artikels zuwenden: der Visualisierung von Metriken in Voronoi-Diagrammen.

Unter Voronoi-Diagrammen verstehen wir die Aufteilung der Euklidischen Ebene in disjunkte Teilflächen abhängig der Distanz zu einer gegebenen Menge von Punkten und gekennzeichnet durch entsprechende Einfärbung entsprechend des jeweils nächsten Punktes.

Im Falle der Euklidischen Metrik, d.h. der Minkowski-Metrik mit $p=2$, ergeben sich somit Grafiken wie die folgende:

![Voronoi-Diagramm der Minkowski-Metrik mit p=2](https://static.kummerlaender.eu/media/voronoi_minkowski_2.png)

Während wir die Definitionen der Metriken bisher im Speziellen für $\mathbb{R}^2$ betrachtet haben, gerät der zugrundeliegende Körper $\mathbb{R}$ mit der konkreten Generierung von Voronoi-Diagrammen als Pixelgrafiken in Konflikt, da wir offensichtlich nicht alle Punkte der Teilflächen bzw. Mengen darstellen können. Die naheliegendste Lösung für dieses Problem ist, die Metriken nur auf $\mathbb{Z}^2$ zu betrachten. Dies ist einfach möglich, da $\mathbb{Z}^2$ eine echte Teilmenge von $\mathbb{R}^2$ ist und eine triviale Bijektion zwischen Punkten in $\mathbb{Z}^2$ und Pixeln auf einem Bildschirm existiert.

![Voronoi-Diagramm der Minkowski-Metrik mit p=1](https://static.kummerlaender.eu/media/voronoi_minkowski_1.png)

Die konkrete Generierung von Voronoi-Diagrammen ist dann einfach möglich - es müssen nur die Punkte der, dem gewünschten Sichtbereich entsprechenden, Teilmenge von $\mathbb{Z}^2$ durchlaufen und abhängig ihrer Distanz zu den Referenzpunkten unter der gewünschten Metrik eingefärbt werden.

```cpp
double minkowski_metric(
	const double         p,
	const imgen::vector& a,
	const imgen::vector& b
) {
	return std::pow(
		  std::pow(std::abs(std::get<0>(a) - std::get<0>(b)), p)
		+ std::pow(std::abs(std::get<1>(a) - std::get<1>(b)), p),
		1.0 / p
	);
}
```

Zur Approximation der Bildmenge $\mathbb{R}_{\geq 0}$ der Metrik-Funktionen verwenden wir `double` Werte, während die Ursprungsmenge $\mathbb{R}^2 \times \mathbb{R}^2$ über zwei Tupel des Typs `std::tuple<std::ptrdiff_t, std::ptrdiff_t>` in unserer Implementierung abgebildet wird.

Die obige Implementierung der Minkowski Metrik in C++ genügt zusammen mit folgendem, auf einer kleinen PPM _Grafikbibliothek_ basierendem, Listing zur Generierung von Voronoi-Diagrammen über einer fixen `reference_vectors` Punktmenge für beliebige $p$.

```cpp
std::pair<double, imgen::colored_vector> get_distance_to_nearest(
	const std::function<double(imgen::vector, imgen::vector)>& metric,
	const imgen::vector a
) {
	constexpr std::array<imgen::colored_vector, 9> reference_vectors{
		imgen::colored_vector{   0,    0, imgen::red()                },
		imgen::colored_vector{ 240,  200, imgen::color{220, 220, 220} },
		imgen::colored_vector{-100,  230, imgen::color{ 94, 113, 106} },
		imgen::colored_vector{ 120, -100, imgen::color{140, 146, 172} },
		imgen::colored_vector{ -42, -200, imgen::color{128, 128, 128} },
		imgen::colored_vector{ 120,   40, imgen::color{ 16,  20,  22} },
		imgen::colored_vector{-150,   50, imgen::color{192, 192, 192} },
		imgen::colored_vector{  60, -128, imgen::color{178, 190, 181} },
		imgen::colored_vector{-240,  -20, imgen::color{ 54,  69,  79} }
	};

	// [...] Bestimmung des nächsten Referenzvektors unter der gegebenen Metrik

	return std::make_pair(*minimal_distance, nearest);
}

void generate_minkowski_voronoi(const double p) {
	const auto metric{[p](const imgen::vector a, const imgen::vector b) -> double {
		return minkowski_metric(p, a, b);
	}};

	imgen::write_ppm(
		"voronoi_" + std::to_string(p) + ".ppm",
		512,
		512,
		[&metric](std::ptrdiff_t x, std::ptrdiff_t y) -> imgen::color {
			const auto& nearest = get_distance_to_nearest(
				metric,
				imgen::vector{x, y}
			);

			if ( nearest.first <= 5.0 ) {
				return imgen::black();
			} else {
				return std::get<2>(nearest.second);
			}
		}
	);
}
```

Die Punktmenge ist dabei die, welche in obigen Beispiel Diagrammen zu betrachten ist. Alles, was wir an dieser Stelle über die zentrale Funktion `imgen::write_ppm` wissen müssen, ist, dass diese formell ein Bild über der Menge $M := \{(x, y) \in \mathbb{Z}^2 \vert \: x \in [-\frac{w}{2}, \frac{w}{2}] \land y \in [-\frac{h}{2}, \frac{h}{2}]\}$ mit Höhe $h$ und Breite $w$ aufspannt und für $\forall \: (x, y) \in M$ die gegebene Funktion $\mathbb{Z} \times \mathbb{Z} \rightarrow [255] \times [255] \times [255]$ aufruft, wobei die Tupel ihrer Bildmenge als Farben interpretiert werden.

Zur Kennzeichnung der Referenzvektoren wird jeweils eine abgeschlossene Kugel unter der verwendeten Metrik mit Radius 5 gezogen. Dies hat den schönen Nebeneffekt, dass wir anhand der Form der Punktmarkierungen schon Rückschlüsse auf die zur Generierung verwendete Metrik ziehen können, da die Markierungen nur skalierte Versionen der Einheitskugel sind, welche wir im vorangehenden Abschnitt besprochen haben.

Der komplette Quellcode der aufgeführten Beispiele ist auf [Github] und [Gitea] unter der MIT Lizenz frei verfügbar und kann so zur Generierung eigener Voronoi Diagramme herangezogen werden.

## Minimalistische Generierung von Pixelgrafiken in C++

Wie bereits angedeutet, basiert der hier gewählte Weg zur Generierung von Voronoi-Diagrammen auf einer minimalistischen C++ _Grafikbibliothek_, welche im Rahmen meiner Experimente zu diesem Thema entstanden ist. Die Ursache dafür war, dass ich von vornherein nur einfache Pixelgrafiken generieren wollte und keinerlei Bedarf für die Vielfalt an Funktionalität hatte, wie sie von Grafikbibliotheken wie [Cairo] dargeboten wird. In solchen Situationen empfielt es sich, dass entstehende Program nicht mit Abhängigkeiten zu großen Frameworks zu überfrachten, sondern das Problem auf das Essenzielle zu reduzieren. In unserem Fall also die Iteration über eine gegebene Bildmenge und die Zuweisung von Farben zu Punkten. Andere Probleme wie Kompression und Animation in GIF Grafiken sind dann besser spezialisierten Werkzeugen wie [Imagemagick] überlassen.

Eines der wohl einfachsten Dateiformate für Pixelgrafiken ist das **P**ortable **P**ix**M**ap Format, dass nur aus der magischen Zahl `P6` gefolgt von Zeilenumbruch-separierter Breite und Höhe sowie einem Stream der Bildpunkte bestehend aus je drei Bytes für Rot, Grün und Blau in dieser Reihenfolge besteht. Dieses primitive Format führt dazu, dass die im Beispiel verwendete `imgen::write_ppm` Funktion sehr einfach zu implementieren ist:

```cpp
void write_ppm(
	const std::string&                                   path,
	const std::size_t                                    width,
	const std::size_t                                    height,
	std::function<color(std::ptrdiff_t, std::ptrdiff_t)> generator
) {
	ppm_pixel_stream file(path, width, height);

	const std::ptrdiff_t min_y = height / 2 * -1;
	const std::ptrdiff_t max_y = height / 2;
	const std::ptrdiff_t min_x = width  / 2 * -1;
	const std::ptrdiff_t max_x = width  / 2;

	for ( std::ptrdiff_t posY = max_y; posY > min_y; --posY ) {
		for ( std::ptrdiff_t posX = min_x; posX < max_x; ++posX ) {
			file << generator(posX, posY);
		}
	}
}
```

Den inhärenten Mehraufwand der Verwendung von `std::function` zur Übergabe der Callbacks für Generierung und Metriken und der Ausgabestreams des Standards in `imgen` sowie der eigentlichen Diagram-Generierung akteptiere ich an dieser Stelle der Klarheit und des Vertrauens in den Compiler wegen. Weiterhin lässt sich die Performance von vielen repetiven Generierungen - die ohnehin nicht an der Ein-Ausgabe-Performance sondern an den konkreten Berechnungen hängt - über Multithreading in verkraftbare Schranken weisen.

## Bewegte Bilder

Das in meinen Augen schönste Resultat dieses Artikels ist die Visualisierung der Transformation von der Mannheimer in die Euklidische Metrik in Form der folgenden GIF Animation:

![Übergang von der Mannheimer in die Euklidische Metrik und zurück](https://static.kummerlaender.eu/media/voronoi_cycle.gif)

Diese Grafik kann dabei vollautomatisch über das, auf [Imagemagick] basierende, Script [voronoi.sh] rekonstruiert werden. Da die Generierung der für die Animation notwendigen zahlreichen Einzelbilder von Voronoi-Diagrammen mit langsam ansteigendem $p$ etwas Zeit kosten kann, lohnt sich die Optimierung durch Aufteilen des Arbeitsaufwands auf mehrere Verarbeitungsstränge. Dies ist einfach möglich, da wir keinerlei veränderliche Daten zwischen einzelnen Voronoi-Diagrammen teilen müssen. Da der Standard mittlerweile schon seit einigen Jahren Unterstützung für Multithreading bietet, gestaltet sich auch die konkrete Umsetzung dieser Optimierung erfreulich kompakt.

```cpp
void generate_parallel_minkowski_voronoi(
	const unsigned int thread_count,
	const double       lower,
	const double       upper,
	const double       epsilon
) {
	std::vector<std::thread> threads;

	const double step = ( upper - lower ) / thread_count;
	double offset     = lower;

	while ( threads.size() < thread_count ) {
		threads.emplace_back([offset, step, epsilon]{
			generate_minkowski_voronoi(
				offset,
				offset + step,
				epsilon
			);
		});

		offset += step;
	}

	generate_minkowski_voronoi(upper);

	for ( auto& thread : threads ) {
		thread.join();
	}
}
```

## Rückblick

Hiermit sind wir am Ende meines ersten textuellen Ausflugs an die Schnittstelle zwischen Mathematik und Software angelangt. Ich hoffe an dieser Stelle, dass die Ausführungen und Beispiele verständlich waren und ich mich, am Anfang meines Studiums der Mathematik stehend, nicht in formelle Fehler verstrickt habe.

Grundsätzlich finde ich Voronoi-Diagramme hilfreich, um eine visuelle Intuition für die Auswirkungen verschiedener Metriken zu gewinnen - gleichwohl diese in höheren Dimensionen schnell in ihrem Nutzen schwindet. Aber auch abgesehen vom praktischen Aspekten sind diese Diagramme eine schöne Möglichkeit in etwas anschaulicherem Kontext mit Mathematik zu spielen und schöne Bilder zu erzeugen.

Ansätze zum Ausbau der im Rahmen dieses Artikels entstandenen Programme - an dieser Stelle noch einmal der Hinweis auf die Quellen bei [Github] und [Gitea] - sind verschiedene Metriken in einem Diagramm zu mischen oder zu gewichten sowie sich praktische Einsatzszenarien für Voronoi-Diagramme anzuschauen. Wenn die Grafiken beispielweise bei dem ein oder anderen meiner Leser die Erinnerung an Strukturen in der Natur wie Bienenwaben oder aufeinandertreffende Seifenblasen geweckt haben, dann liegt das daran, dass sich Prozesse dieser Art tatsächlich über Voronoi-Diagramme betrachten lassen. Der entsprechende [Wikipedia-Artikel] liefert hier als Abschluss eine Auflistung zahlreicher Anwendungsbeispiele.

[Github]: https://github.com/KnairdA/voronoi/
[Gitea]: https://code.kummerlaender.eu/adrian/voronoi/
[Cairo]: https://www.cairographics.org/
[Imagemagick]: http://www.imagemagick.org/
[voronoi.sh]: http://code.kummerlaender.eu/adrian/voronoi/src/branch/master/voronoi.sh
[Wikipedia-Artikel]: https://en.wikipedia.org/wiki/Voronoi_diagram
