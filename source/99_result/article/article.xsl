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
	<datasource type="main"    mode="iterate" source="target/02_data/articles.xml" target="article"/>
	<datasource type="support" mode="full"    source="source/00_content/meta.xml"  target="meta"/>
	<target     mode="xpath"   value="xalan:nodeset($datasource)/datasource/article/entry/@handle"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/article/entry/title"/>
</xsl:template>

<xsl:template match="article/entry">
	<div class="last article">
		<h2>
			» <a href="{$url}/article/{@handle}"><xsl:value-of select="./title"/></a>
		</h2>
		<p class="info">
			<xsl:call-template name="format-date">
				<xsl:with-param name="date" select="./date"/>
				<xsl:with-param name="format" select="'x. M Y'"/>
			</xsl:call-template> 
			| <xsl:for-each select="tags/tag">
				<a href="{$url}/tag/{.}">
					<xsl:value-of select="."/>
				</a>
			</xsl:for-each>
			| Adrian Kummerländer
		</p>
		<xsl:copy-of select="./content/*"/>
	</div>
</xsl:template>

</xsl:stylesheet>
