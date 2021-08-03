<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:output
	method="xml"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="no"
/>

<xsl:variable name="root" select="datasource"/>

<xsl:template match="/">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author"             content="{$root/meta/author}" />
	<meta name="description"        content="{$root/meta/description}" />
	<meta name="robots"             content="all"/>
	<meta name="viewport"           content="width=device-width,initial-scale=1.0"/>

	<link rel="stylesheet"    type="text/css"             href="/main.css" />
	<link rel='alternate'     type='application/atom+xml' href='/atom.xml'/>
	<link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22256%22 height=%22256%22 viewBox=%220 0 100 100%22><rect width=%22100%22 height=%22100%22 rx=%2220%22 fill=%22%23ff8800%22></rect><path d=%22%22 fill=%22%23fff%22></path></svg>"/>

	<xsl:if test="//*[(self::p or self::span) and @class = 'math']">
		<link rel="stylesheet" type="text/css" href="https://static.kummerlaender.eu/katex/katex.min.css" />
	</xsl:if>

	<title>
		<xsl:call-template name="title-text"/> @ <xsl:value-of select="$root/meta/title"/>
	</title>
</head>
<body>
	<div id="navigation" class="center border_bottom">
		<h1>
			<xsl:value-of select="$root/meta/title"/>
		</h1>

		<ul class="buttonlist">
			<xsl:apply-templates select="$root/meta/header/navigation/link" mode="master"/>
		</ul>
	</div>

	<div id="content" class="center">
		<xsl:apply-templates />
	</div>

	<div id="tags" class="center border_top border_bottom">
		<ul class="buttonlist">
			<xsl:apply-templates select="datasource/meta/tags/entry" mode="master"/>
		</ul>
	</div>

	<div id="footer" class="center">
		<a href="{$root/meta/footer/info/@href}">
			<xsl:value-of select="$root/meta/footer/info/text()"/>
		</a>

		<ul class="buttonlist">
			<xsl:apply-templates select="$root/meta/footer/navigation/link" mode="master"/>
		</ul>
	</div>
</body>
</html>
</xsl:template>

<xsl:template match="meta/tags/entry" mode="master">
	<li>
		<a href="/tag/{@handle}">
			<xsl:value-of select="@handle"/>
		</a>
	</li>
</xsl:template>

<xsl:template match="link" mode="master">
	<li>
		<a href="{@href}">
			<xsl:value-of select="text()"/>
		</a>
	</li>
</xsl:template>

<xsl:template match="text()|@*"/>

</xsl:stylesheet>
