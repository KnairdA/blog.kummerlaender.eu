<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:include href="[utility/datasource.xsl]"/>
<xsl:include href="[utility/formatter.xsl]"/>

<xsl:template match="source/pages">
	<pages>
		<xsl:apply-templates select="./*"/>
	</pages>
</xsl:template>

<xsl:template match="file[./extension = '.md']">
	<entry handle="{./name}">
		<xsl:choose>
			<xsl:when test="./extension = '.md'">
				<xsl:call-template name="formatter">
					<xsl:with-param name="format">/usr/bin/markdown</xsl:with-param>
					<xsl:with-param name="source" select="InputXSLT:read-file(./full)/text()"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="./extension = '.xml'">
				<xsl:copy-of select="InputXSLT:read-file(./full)/*"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="InputXSLT:read-file(./full)/text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</entry>
</xsl:template>

</xsl:stylesheet>
