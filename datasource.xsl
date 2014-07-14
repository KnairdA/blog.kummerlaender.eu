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
	omit-xml-declaration="no"
	encoding="UTF-8"
	indent="yes"
/>

<xsl:include href="utility/reader.xsl"/>
<xsl:include href="datasource/entry.xsl"/>

<xsl:template match="data/source">
	<datasource>
		<xsl:apply-templates select="@*|node()"/>
	</datasource>
</xsl:template>

<xsl:template match="source/pages">
	<pages>
		<xsl:apply-templates select="./*"/>
	</pages>
</xsl:template>

<xsl:template match="file[./extension = '.md']">
	<xsl:call-template name="entry">
		<xsl:with-param name="file" select="."/>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
