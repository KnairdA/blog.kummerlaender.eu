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

<xsl:include href="utility/context.xsl"/>
<xsl:include href="utility/reader.xsl"/>

<xsl:variable name="context" select="meta"/>

<xsl:template name="generate_datasource">
	<xsl:param name="source"/>
	<xsl:param name="transformation"/>

	<xsl:call-template name="generate_in_context">
		<xsl:with-param name="input"          select="$source"/>
		<xsl:with-param name="transformation" select="string($transformation/full)"/>
		<xsl:with-param name="target"         select="concat($context/target/datasource, '/', $transformation/name, '.xml')"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="read_datasource">
	<xsl:param name="name"/>

	<xsl:variable name="datasource">
		<xsl:call-template name="reader">
			<xsl:with-param name="path" select="concat($context/target/datasource, '/', $name)"/>
		</xsl:call-template>
	</xsl:variable>

	<datasource name="{$name}">
		<xsl:copy-of select="xalan:nodeset($datasource)/datasource/*"/>
	</datasource>
</xsl:template>

<xsl:template name="compile">
	<xsl:param name="transformation"/>

	<xsl:variable name="stylesheet">
		<xsl:call-template name="reader">
			<xsl:with-param name="path" select="$transformation/full"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="datasources" select="
		xalan:nodeset($stylesheet)/*[name() = 'xsl:stylesheet']
		                          /*[name() = 'xsl:variable' and @name = 'datasources']
	"/>

	<xsl:call-template name="transform_in_context">
		<xsl:with-param name="input">
			<xsl:for-each select="$datasources/file">
				<xsl:call-template name="read_datasource">
					<xsl:with-param name="name" select="@name"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:with-param>
		<xsl:with-param name="transformation" select="$stylesheet"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="meta">
	<xsl:variable name="source">
		<xsl:call-template name="transform_in_context">
			<xsl:with-param name="transformation" select="string('[source.xsl]')"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:for-each select="InputXSLT:read-directory(./source/datasource)/entry[./extension = '.xsl']">
		<xsl:call-template name="generate_datasource">
			<xsl:with-param name="source"         select="$source"/>
			<xsl:with-param name="transformation" select="."/>
		</xsl:call-template>
	</xsl:for-each>

	<xsl:for-each select="InputXSLT:read-directory(./source/compiler)/entry[./extension = '.xsl']">
		<xsl:call-template name="compile">
			<xsl:with-param name="transformation" select="."/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
