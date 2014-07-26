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

<xsl:variable name="meta">
	<datasource type="main"  mode="full" source="target/01_files/source.xml"  target="files"/>
	<target     mode="plain" value="tags.xml"/> 
</xsl:variable>

<xsl:template match="files/tags/*">
	<entry handle="{name()}">
		<xsl:apply-templates />
	</entry>
</xsl:template>

<xsl:template match="tags/*/file[./extension = '.md']">
	<article handle="{substring(./name, 12, string-length(./name))}"/>
</xsl:template>

</xsl:stylesheet>
