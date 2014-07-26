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
	<datasource type="main"    mode="full" source="source/00_content/meta.xml" target="meta"/>
	<datasource type="support" mode="full" source="target/02_data/tags.xml"    target="tags"/>
	<target     mode="plain"   value="meta.xml"/> 
</xsl:variable>

<xsl:template match="meta">
	<xsl:copy-of select="./*"/>
</xsl:template>

<xsl:template match="tags">
	<tags>
		<xsl:apply-templates />
	</tags>
</xsl:template>

<xsl:template match="tags/entry">
	<entry handle="{@handle}"/>
</xsl:template>

</xsl:stylesheet>
