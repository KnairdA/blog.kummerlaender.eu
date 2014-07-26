<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="InputXSLT"
>

<xsl:output
	method="xml"
	omit-xml-declaration="no"
	encoding="UTF-8"
	indent="yes"
/>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"/>
	<target     mode="plain" value="source.xml"/> 
</xsl:variable>

<xsl:template name="list_source">
	<xsl:param name="base"/>

	<xsl:for-each select="InputXSLT:read-directory($base)/entry">
		<xsl:choose>
			<xsl:when test="@type = 'directory'">
				<xsl:element name="{./name}">
					<xsl:call-template name="list_source">
						<xsl:with-param name="base" select="./full"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<file>
					<xsl:copy-of select="./*"/>
				</file>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template match="datasource">
	<xsl:call-template name="list_source">
		<xsl:with-param name="base">[source/00_content]</xsl:with-param>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
