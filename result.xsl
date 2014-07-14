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

<xsl:include href="utility/generator.xsl"/>

<xsl:variable name="meta" select="/data/meta"/>

<xsl:template match="data/datasource">
	<result>
		<xsl:apply-templates select="@*|node()"/>
	</result>
</xsl:template>

<xsl:template match="datasource/pages">
	<pages>
		<xsl:apply-templates select="./*"/>
	</pages>
</xsl:template>

<xsl:template match="pages/entry">
	<xsl:call-template name="generator">
		<xsl:with-param name="input">
			<data>
				<xsl:copy-of select="$meta"/>
				<xsl:copy-of select="."/>
			</data>
		</xsl:with-param>
		<xsl:with-param name="transformation">[template/page.xsl]</xsl:with-param>
		<xsl:with-param name="target">
			<xsl:value-of select="$meta/target/directory"/>/pages/<xsl:value-of select="./@handle"/>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
