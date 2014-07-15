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
	indent="yes"
/>

<xsl:include href="utility/transformer.xsl"/>

<xsl:variable name="context" select="/"/>

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

<xsl:template match="meta">
	<xsl:call-template name="transform_in_context">
		<xsl:with-param name="transformation">[result.xsl]</xsl:with-param>
		<xsl:with-param name="input">
			<xsl:call-template name="transform_in_context">
				<xsl:with-param name="transformation">[datasource.xsl]</xsl:with-param>
				<xsl:with-param name="input">
					<xsl:call-template name="transform_in_context">
						<xsl:with-param name="transformation">[source.xsl]</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
