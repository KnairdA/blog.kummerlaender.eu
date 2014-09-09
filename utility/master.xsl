<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
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

<xsl:variable name="root" select="/datasource"/>

<xsl:template name="list_tags">
	<ul>
		<xsl:for-each select="$root/meta/tags/entry">
			<li>
				<a href="/tag/{@handle}">
					<xsl:value-of select="@handle"/>
				</a>
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>

<xsl:template match="/">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Adrian Kummerländer" />
	<meta name="robots" content="all"/>
	<meta name="viewport" content="width=device-width,initial-scale=1.0"/>

	<title><xsl:call-template name="title-text"/> @ <xsl:value-of select="$root/meta/title"/></title>
	<link rel="stylesheet" type="text/css" href="/main.css" />

	<link rel="shortcut icon" type="image/x-icon" href="favicon.ico" /> 
</head>
<body>
	<div id="wrapper">
		<div id="content">
			<div id="nav_wrap">
				<h1><xsl:value-of select="$root/meta/title"/></h1>
				<ul>
					<li><a href="/0">Start</a></li>
					<li><a href="/archive">Archive</a></li>
					<li><a href="/category/projects">Projects</a></li>
					<li><a href="/page/contact">Contact</a></li>
					<li class="last_item"><a href="/atom.xml">Feed</a></li>
				</ul>
			</div>
			<div id="main">
				<xsl:apply-templates />
			</div>
			<div id="footer_wrap">
				<div class="taglist">
					<xsl:call-template name="list_tags"/>
				</div>
			</div>
			<div id="last_line">
				<a href="https://github.com/KnairdA/blog.kummerlaender.eu">Made with XSLT</a>
				<ul>
					<li><a href="/page/contact">Contact</a></li>
					<li class="last_item"><a href="/atom.xml">Feed</a></li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
</xsl:template>

<xsl:template match="text()|@*"/>

</xsl:stylesheet>
