<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:template name="merge_datasource">
	<xsl:param name="main"/>
	<xsl:param name="support"/>

	<datasource>
		<xsl:copy-of select="$main"/>
		<xsl:copy-of select="$support"/>
	</datasource>
</xsl:template>

<xsl:template name="formatter">
	<xsl:param name="format"/>
	<xsl:param name="source"/>

	<xsl:copy-of select="InputXSLT:external-command(
		$format,
		$source
	)/self::command/node()"/>
</xsl:template>

</xsl:stylesheet>
