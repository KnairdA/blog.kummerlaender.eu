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
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="no"
/>

<xsl:variable name="source">source</xsl:variable>
<xsl:variable name="target">target</xsl:variable>

<xsl:template name="generate">
	<xsl:param name="input"/>
	<xsl:param name="transformation"/>

	<xsl:copy-of select="InputXSLT:generate(
		$input,
		string($transformation)
	)/self::generation/node()"/>
</xsl:template>

<xsl:template match="/">
	<xsl:variable name="list_source">
		<datasource>
			<meta>
				<source><xsl:value-of select="$source"/></source>
				<target><xsl:value-of select="$target"/></target>
			</meta>
		</datasource>
	</xsl:variable>

	<xsl:variable name="plan_source">
		<xsl:call-template name="generate">
			<xsl:with-param name="input" select="$list_source"/>
			<xsl:with-param name="transformation">list.xsl</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="process_source">
		<xsl:call-template name="generate">
			<xsl:with-param name="input" select="$plan_source"/>
			<xsl:with-param name="transformation">plan.xsl</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="summarize_source">
		<xsl:call-template name="generate">
			<xsl:with-param name="input" select="$process_source"/>
			<xsl:with-param name="transformation">process.xsl</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:call-template name="generate">
		<xsl:with-param name="input" select="$summarize_source"/>
		<xsl:with-param name="transformation">summarize.xsl</xsl:with-param>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
