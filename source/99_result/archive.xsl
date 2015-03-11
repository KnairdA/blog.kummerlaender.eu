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
	<datasource type="support" mode="full" source="00_content/microblog.xml" target="microblog"/>
	<target     mode="plain"   value="archive/index.html"/>
</xsl:variable>

<xsl:template name="title-text">Archive</xsl:template>

<xsl:template match="datasource">
	<div class="archiv columns">
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="articles">
	<div class="column">
		<xsl:text>Past articles:</xsl:text>

		<ol class="topline articlelist archivlist">
			<xsl:apply-templates select="entry"/>
		</ol>
	</div>
</xsl:template>

<xsl:template match="microblog">
	<div class="column">
		<a href="https://twitter.com/KnairdA">Microblog:</a>

		<ul class="prettylist sparselist topline">
			<xsl:apply-templates select="item[substring(text, 1, 1) != '@'][position() &lt;= 9]" />
		</ul>
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
		<a href="/article/{@handle}">
			<xsl:value-of select="title"/>
		</a>
	</li>
</xsl:template>

<xsl:template match="microblog/item">
	<li>
		<em>»</em>
		<a href="{link}">
			<xsl:value-of select="text" disable-output-escaping="yes" />
		</a>
	</li>
</xsl:template>

</xsl:stylesheet>
