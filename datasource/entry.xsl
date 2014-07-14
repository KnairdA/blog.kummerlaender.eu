<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:include href="[utility/formatter.xsl]"/>

<xsl:template name="entry">
	<xsl:param name="file"/>

	<entry handle="{$file/name}">
		<xsl:choose>
			<xsl:when test="$file/extension = '.md'">
				<xsl:call-template name="formatter">
					<xsl:with-param name="format">/usr/bin/markdown</xsl:with-param>
					<xsl:with-param name="source" select="InputXSLT:read-file($file/full)/text()"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$file/extension = '.xml'">
				<xsl:copy-of select="InputXSLT:read-file($file/full)/*"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="InputXSLT:read-file($file/full)/text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</entry>
</xsl:template>

</xsl:stylesheet>
