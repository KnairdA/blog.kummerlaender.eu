# Lighttpd Konfiguration für Symphony

Da ich die Neuauflage dieser Seite nicht mehr auf Wordpress, sondern auf dem [Symphony CMS](http://http://symphony-cms.com/) aufgebaut habe, aber nicht den  Webserver wechseln wollte, musste ich einen Weg finden die Apache URL-Rewrites in Lighttpd nachzubilden. 

Von den im Netz verfügbaren [Beispielen](http://blog.ryara.net/2009/12/05/lighttpd-rewrite-rules-for-symphony-cms/) hat jedoch keines ohne Einschränkungen funktioniert. Aus diesem Grund habe ich auf Basis der oben verlinkten Konfiguration ein funktionierendes Regelwerk geschrieben:

```
url.rewrite-once += ( 
	"^/favicon.ico$" => "$0",
	"^/robots.txt$" => "$0",
	"^/symphony/(assets|content|lib|template)/.*$" => "$0",
	"^/workspace/([^?]*)" => "$0",
	"^/symphony(\/(.*\/?))?(.*)\?(.*)$" => "/index.php?symphony-page=$1&mode=administration&$4&$5",
	"^/symphony(\/(.*\/?))?$" => "/index.php?symphony-page=$1&mode=administration",
	"^/([^?]*/?)(\?(.*))?$" => "/index.php?symphony-page=$1&$3" 
)
```

Dieses läuft mit der aktuellsten Symphony Version einwandfrei. Zu finden ist die Konfiguration übrigens mit den restlichen Quellen meines neuen Webseiten-Setups auf [Github](https://github.com/KnairdA/blog.kummerlaender.eu).
