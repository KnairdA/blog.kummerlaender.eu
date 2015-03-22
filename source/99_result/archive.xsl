<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="full" source="02_meta/articles.xml"     target="articles"/>
	<datasource type="support" mode="full" source="02_meta/meta.xml"         target="meta"/>
	<target     mode="plain"   value="archive/index.html"/>
</xsl:variable>

<xsl:template name="title-text">Archive</xsl:template>

<xsl:template match="articles">
	<h3>
		<xsl:text>Past articles</xsl:text>
	</h3>

	<ol class="articlelist archivlist">
		<xsl:apply-templates select="entry"/>
	</ol>
</xsl:template>

<xsl:template match="articles/entry">
	<li class="dateitem">
		<xsl:value-of select="@handle"/>
	</li>
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="entry/article">
	<li>
		<a href="/article/{@handle}">
			<xsl:value-of select="title"/>
		</a>
	</li>
</xsl:template>

</xsl:stylesheet>
