# Gedanken zu (de)-zentralen Netzen

Das Internet war von Anfang an als dezentrales Netzwerk gedacht und ist es auch - bis zu einem bestimmten Grad. Hardwareseitig.

Auf der Seite der Dienste und Anwendungen wird es jedoch zunehmend zentralisierter. Nachrichten werden nicht mehr per Mail sondern über zentrale Plattformen wie Facebook, Google+ etc. ausgetauscht. Kommunikation mit Freunden läuft nicht mehr direkt sondern über zentrale Knotenpunkte und unsere Daten liegen immer mehr nicht lokal auf eigenen Medien verteilt sondern zentralisiert in der Cloud. Rechenleistung wird weniger von eigenen Servern sondern viel mehr von großen Rechnerverbünden on Demand bereitgestellt.

Das alles ist auf den ersten Blick schön und macht vieles einfacher, aber natürlich bringt es wie alles auch Probleme mit sich.  
In diesem Fall ist es ein ziemlich großes Problem.

Dadurch das sich immer mehr Kommunikation, ein Teil der Gesellschaft ins Netz verlagert und neue Dinge auf Basis des Internet geschaffen werden wird die Abhängigkeit von diesen zentralen Dienstleistern immer größer. Für Unternehmen, Regierungen und die Verwertungsindustrie eröffnen sich so Ansatzpunkte zur Kontrolle großer Teile der Information und Kommunikation.

Auswirkungen dieser Möglichkeiten schlagen sich beispielsweise regelmäßig in Gesetzesinitiativen wie dem Jugendmedienschutz-Staatsvertrag oder dem Zugangserschwerungsgesetz nieder. Bis jetzt konnten diese Repressionen und Gefahren immer mehr oder weniger abgewendet  werden - doch das muss nicht immer so sein.

Auch aus Sicht des Datenschutzes und beim Blick auf die AGBs diverser Plattformen sollte einem die Gefahr, die übermäßiges Verlagern von Daten in fremde Hände birgt, bewusst werden.

## Alternativen

Es gibt Möglichkeiten das Unterdrücken und Kontrollieren von Kommunikation zumindest so lange das Netz selbst noch verfügbar ist zu erschweren. Ein erster Schritt kann das Ersetzen von Plattformen wie Facebook oder Twitter mit Software wie z.B. [Diaspora](https://joindiaspora.com/) oder [StatusNet](http://status.net/) sein. Daten speichern und Tauschen lässt sich - auch auf Hardware die unter eigener Kontrolle steht - realisieren dank Projekten wie [OwnCloud](http://owncloud.org/). Zum Tauschen von Daten gibt es heute schon weit verbreitete dezentrale Protokolle wie BitTorrent. InstantMessaging ist bequem über [Jabber](http://einfachjabber.de/) möglich. Auch anonymes Nutzen des Internet und anonymes Bereitstellen von Anwendungen im Internet ist mit [Tor](https://www.torproject.org/) machbar.

Diese Dienste lassen sich alle über eigene Server verwenden - wer wie ich einen Schritt weiter gehen möchte kann es auch mit einem Rechner bei sich zu Hause, über die eigene Internetanbindung machen. Hier gibt es dank der zunehmenden Beliebtheit von [ARM-Prozessoren](http://de.wikipedia.org/wiki/ARM-Architektur) einen stetigen Nachschub an Hardware. Beispiele hierfür sind die [CuBox](http://www.solid-run.com/) und die Steckdosenrechner von [Marvell](http://www.marvell.com/solutions/plug-computers/) wie der [SheevaPlug](http://de.wikipedia.org/wiki/SheevaPlug) mit dem ich persönlich über die letzten zwei Jahre sehr gute Erfahrungen gemacht habe.  
Diese Computer vereinen für die üblichen Fälle gut ausreichende Rechenleistung mit einem sehr geringen Stromverbrauch (aktuell etwa 5 Watt) was auch bei ganzjährlichem Betrieb kaum Kosten entstehen lässt.

## Ausblick

Man stelle sich vor jeder hätte einen solchen Server bei sich am Laufen. Dieser Server könnte über eine Diaspora Instanz ein Teil eines globalen, dezentralen, sozialen Netzwerks sein, über einen Jabber-Server Echtzeitkommunikation ermöglichen und über OwnCloud Daten freigeben. Jeder könnte jeden Service anbieten und wenn eine Instanz ausfällt betrifft es nur einen: den Ausgefallenen.  
Ein Projekt das versucht diese Idee zu verwirklichen ist die [Freedom](http://wiki.debian.org/FreedomBox)[Box](http://freedomboxfndn.mirocommunity.org/video/9/elevate-2011).  

Zentrale Dienste könnten in diesem Modell natürlich immernoch existieren - jedoch bestünde im besten Fall auch die Möglichkeit
die Daten vom Dienst zu trennen und so Freiheit zu erlangen. Das [Unhosted-Projekt](http://unhosted.org/) ermöglich das schon jetzt durch
ein JavaScript-Framework welches es erlaubt Anwendungen zu schreiben die auf einem zentralen Server laufen, die Daten jedoch auf den 
Rechnern der Nutzer selbst speichern.

Eine ähnliche Idee verfolgt auch Opera durch die Integration eines Webservers in den Browser mit [Unite](http://unite.opera.com/applications/). Jedoch ist Unite leider kein direktes Peer2Peer Netzwerk da aller Netzverkehr duch Opera-Proxys geroutet wird und sich das Unternehmen in den AGBs das Recht einräumt Inhalte zu löschen und zu blockieren.  
Prinzipiell ist diese Idee für den normalen Nutzer jedoch vermutlich sogar besser als die vieler lokaler Heimserver: "Ich mache das Fenster für das Internet auf und wenn ich es zu mache bin ich nicht mehr im Internet - auch nicht meine Inhalte.".

Dieser Ansatz in einer Software richtig verpackt, so dass für den Nutzer kein sichtbarer Unterschied besteht und er nicht direkt merkt das er sich seine Dienste selbst zu Verfügung stellt, könnte dem Ziel eines auch aus Sicht der Dienste dezentralen Netzes sicher auf die Sprünge helfen.
