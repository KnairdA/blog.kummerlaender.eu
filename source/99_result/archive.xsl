<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="full" source="target/03_meta/articles.xml" target="articles"/>
	<datasource type="support" mode="full" source="target/03_meta/meta.xml" target="meta"/>
	<target     mode="plain"   value="archive/index.html"/> 
</xsl:variable>

<xsl:template name="title-text">Archive</xsl:template>

<xsl:template match="articles">
	<div class="left articlelist archivlist">
		Past articles:
		<ol>
			<xsl:apply-templates />
		</ol>
	</div>
</xsl:template>

<xsl:template match="articles/entry">
	<li class="dateitem">
		<xsl:value-of select="@handle"/>
	</li>
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="entry/article">
	<li>
		<a href="{$url}/article/{@handle}">
			<xsl:value-of select="title"/>
		</a>
	</li>
</xsl:template>

</xsl:stylesheet>
