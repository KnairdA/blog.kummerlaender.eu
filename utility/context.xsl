<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:include href="generator.xsl"/>
<xsl:include href="transformer.xsl"/>

<xsl:variable name="context" select="meta"/>

<xsl:template name="transform_in_context">
	<xsl:param name="input"/>
	<xsl:param name="transformation"/>

	<xsl:call-template name="transformer">
		<xsl:with-param name="input">
			<data>
				<xsl:copy-of select="$context"/>
				<xsl:copy-of select="$input"/>
			</data>
		</xsl:with-param>
		<xsl:with-param name="transformation" select="$transformation"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="generate_in_context">
	<xsl:param name="input"/>
	<xsl:param name="transformation"/>
	<xsl:param name="target"/>

	<xsl:call-template name="generator">
		<xsl:with-param name="input">
			<data>
				<xsl:copy-of select="$context"/>
				<xsl:copy-of select="$input"/>
			</data>
		</xsl:with-param>
		<xsl:with-param name="transformation" select="$transformation"/>
		<xsl:with-param name="target"         select="$target"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="text()|@*"/>

</xsl:stylesheet>
