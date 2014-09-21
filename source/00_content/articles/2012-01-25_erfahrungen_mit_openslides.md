# Erfahrungen mit OpenSlides

Für den letzten Kreisparteitag des [KV Konstanz](http://piraten-konstanz.de) suchte ich nach einer möglichst bequemen Möglichkeit die aktuelle Tagesordnung auf einem Beamer abzubilden. Gestoßen bin ich dabei auf die freie Software [OpenSlides](http://openslides.org/de/index.html).

OpenSlides ist ein auf dem Python-Webframework [Django](https://www.djangoproject.com/) basierendes Präsentationsystem zur Darstellung und Steuerung von Tagesordnungen, Anträgen, Abstimmungen und Wahlen - also ein für die Organisation von Parteitagen sehr gut geeignetes Werkzeug.

Das UI ist dabei in den Administrationsbereich, über den sämtliche Daten eingegeben werden können, und eine Beamer-Ansicht geteilt. Beide dieser Komponenten laufen in einem gewöhnlichen Webbrowser. Das Aussehen lässt sich also einfach durch Modifikation der Templates und der CSS-Formatierungen an die eigenen Wünsche anpassen. 

![KPT OpenSlides](http://static.kummerlaender.eu/media/kpt_it.jpg){: .full}

Nachdem ich anfangs alle Wahlen, bekannten Teilnehmer und Anträge in das Redaktionsystem eingespiesen hatte, ließ sich am Parteitag selbst dann mit wenigen Mausklicks eine ansprechende Präsentation des aktuellen Themas erzeugen.  
Wahlergebnisse waren ebenso wie die Annahme oder Ablehnung eines Antrags über entsprechende Formulare schnell eingepflegt und dargestellt.
Sehr gefallen hat mir im Vorfeld auch die Möglichkeit der Generierung von Antragsbüchern als PDF.

![KPT OpenSlides](http://static.kummerlaender.eu/media/kpt_openslides.png){: .full}

Der Funktionsumfang von OpenSlides geht jedoch über die bloße Darstellung der TO auf einem Beamer hinaus. So kann wenn gewünscht jeder Teilnehmer über sein eigenes Endgerät auf das Webinterface zugreifen und als Deligierter an der Versammlung teilnehmen - also Abstimmen, Wählen und Anträge stellen.  
Theoretisch ermöglicht es diese Software also - bei entsprechender Authentifizierung - die Durchführung von dezentralen Versammlungen. Aber auch wenn dies z.B. aufgrund von zur Nachvollziehbarkeit nötiger Klarnamenspflicht nicht in Frage kommt, ergibt sich doch so für die Teilnehmer immerhin die Möglichkeit den Ablauf auf einem eigenen Gerät nachzuverfolgen.

Der einzige Punkt der mich wirklich störte war die fehlende Anzeige von Wahlergebnissen der Teilnehmer die eine Wahl verloren hatten. Die jeweilige Stimmenzahl war im Frontend erst sichtbar nachdem der entsprechende Kandidat als Sieger markiert worden war.  
Doch auch dieses Problem ließ sich - OpenSource sei Dank - schnell über manuelles Eingreifen im Quelltext korrigieren:

~~~
--- /home/adrian/Downloads/original_views.py
+++ /opt/hg.openslides.org/openslides/agenda/views.py
@@ -132,14 +132,11 @@
             for poll in assignment.poll_set.all():
                 if poll.published:
                     if candidate in poll.options_values:
-                        if assignment.is_elected(candidate):
-                            option = Option.objects.filter(poll=poll).filter(user=candidate)[0]
-                            if poll.optiondecision:
-                                tmplist[1].append([option.yes, option.no, option.undesided])
-                            else:
-                                tmplist[1].append(option.yes)
+                        option = Option.objects.filter(poll=poll).filter(user=candidate)[0]
+                        if poll.optiondecision:
+                            tmplist[1].append([option.yes, option.no, option.undesided])
                         else:
-                            tmplist[1].append("")
+                            tmplist[1].append(option.yes)
                     else:
                         tmplist[1].append("-")
             votes.append(tmplist)
~~~
{: .language-diff}

OpenSlides ist wirklich ein tolles Stück Software und ich kann nur jedem der vor der Aufgabe steht eine Versammlung zu organisieren, sei es die eines Vereins oder wie in meinem Fall die einer Partei, empfehlen sich es einmal näher anzusehen.  
Weitere Angaben zur Installation und Konfiguration finden sich auf der [Webpräsenz](http://openslides.org/de/index.html) und im [Quell-Archiv](http://openslides.org/download/openslides-1.1.tar.gz).
