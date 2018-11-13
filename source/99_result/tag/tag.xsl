<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="02_meta/tags.xml" target="tag"/>
	<datasource type="support" mode="full"    source="02_meta/meta.xml" target="meta"/>
	<target     mode="xpath"   value="concat($datasource/tag/entry/@handle, '/index.html')"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/tag/entry/@handle"/>
</xsl:template>

<xsl:template match="tag/entry">
	<h3>
		<xsl:text>All articles tagged as &#187;</xsl:text>
		<xsl:value-of select="@handle"/>
		<xsl:text>&#171;</xsl:text>
	</h3>

	<ol class="articlelist archivlist">
		<xsl:apply-templates />
	</ol>
</xsl:template>

<xsl:template match="tag/entry/article">
	<li>
		<a href="/article/{@handle}">
			<xsl:value-of select="title"/>
		</a>
	</li>
</xsl:template>

</xsl:stylesheet>
