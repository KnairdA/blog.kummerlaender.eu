<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:output
	method="xml"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="yes"
/>

<xsl:template match="data">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Adrian Kummerländer" />
	<meta name="robots" content="all"/>
	<meta name="viewport" content="width=device-width,initial-scale=1.0"/>

	<title><xsl:call-template name="title-text"/></title>
	<link rel="stylesheet" type="text/css" href="{/meta/target/url}/main.css" />

	<link rel="shortcut icon" type="image/x-icon" href="favicon.ico" /> 
</head>
<body>
	<div id="wrapper">
		<div id="content">
			<div id="nav_wrap">
				<h1><xsl:value-of select="meta/title"/></h1>
				<ul>
					<li><a href="{/meta/target/url}">Start</a></li>
					<li><a href="{/meta/target/url}/archiv">Archiv</a></li>
					<li><a href="{/meta/target/url}/projekte">Projekte</a></li>
					<li><a href="{/meta/target/url}/seiten/kontakt">Kontakt</a></li>
					<li class="last_item"><a href="{/meta/target/url}/rss">RSS</a></li>
				</ul>
			</div>
			<div id="main">
				<xsl:apply-templates select="/entry"/>
			</div>
			<div id="footer_wrap">
			</div>
			<div id="last_line">
				<a href="https://github.com/KnairdA/InputXSLT">Gemacht mit XSLT</a>
				<ul>
					<li><a href="{/meta/target/url}/seiten/kontakt">Kontakt</a></li>
					<li class="last_item"><a href="{/meta/target/url}/rss">RSS</a></li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
</xsl:template>

</xsl:stylesheet>

