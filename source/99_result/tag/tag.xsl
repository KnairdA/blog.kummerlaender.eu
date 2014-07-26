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
<xsl:include href="[utility/date-time.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="target/03_meta/tags.xml"    target="tag"/>
	<datasource type="support" mode="full"    source="source/00_content/meta.xml" target="meta"/>
	<datasource type="support" mode="full"    source="target/02_data/tags.xml"    target="tags"/>
	<target     mode="xpath"   value="xalan:nodeset($datasource)/datasource/tag/entry/@handle"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/tag/entry/@handle"/>
</xsl:template>

<xsl:template match="tag/entry">
	<div class="archiv left articlelist archivlist">
		All articles tagged as &#187;<xsl:value-of select="@handle"/>&#171;
		<ol>
			<xsl:apply-templates />
		</ol>
	</div>
</xsl:template>

<xsl:template match="tag/entry/article">
	<li>
		<xsl:call-template name="format-date">
			<xsl:with-param name="date" select="date"/>
			<xsl:with-param name="format" select="'x. M Y'"/>
		</xsl:call-template>
		» <a href="{$url}/article/{@handle}"><xsl:value-of select="title"/></a>
	</li>
</xsl:template>

</xsl:stylesheet>
