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

<xsl:include href="[utility/datasource.xsl]"/>
<xsl:include href="[utility/formatter.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"  mode="full" source="target/01_files/source.xml" target="files"/>
	<target     mode="plain" value="pages.xml"/> 
</xsl:variable>

<xsl:template match="files/pages/file[./extension = '.md']">
	<entry handle="{./name}">
		<xsl:call-template name="formatter">
			<xsl:with-param name="format">/usr/bin/markdown</xsl:with-param>
			<xsl:with-param name="source" select="InputXSLT:read-file(./full)/text()"/>
		</xsl:call-template>
	</entry>
</xsl:template>

</xsl:stylesheet>
