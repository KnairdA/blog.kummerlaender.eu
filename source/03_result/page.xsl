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

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="target/02_data/pages.xml"   target="page"/>
	<datasource type="support" mode="full"    source="source/00_content/meta.xml" target="meta"/>
	<target     mode="xpath"   value="concat('pages/', xalan:nodeset($input)/datasource/page/entry/@handle)"/> 
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/page/entry/title"/>
</xsl:template>

<xsl:template match="page/entry">
	<div class="last article">
		<h3><xsl:value-of select="./title"/></h3>
		<xsl:copy-of select="./content/*"/>
	</div>
</xsl:template>

</xsl:stylesheet>
