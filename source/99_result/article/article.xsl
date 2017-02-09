<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>
<xsl:include href="[utility/xhtml.xsl]"/>
<xsl:include href="[utility/date-time.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="01_data/articles.xml" target="article"/>
	<datasource type="support" mode="full"    source="02_meta/meta.xml"     target="meta"/>
	<target     mode="xpath"   value="concat($datasource/article/entry/@handle, '/index.html')"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/article/entry/title"/>
</xsl:template>

<xsl:template match="article/entry">
	<div class="article">
		<h2>
			<xsl:text>» </xsl:text>
			<a href="/article/{@handle}">
				<xsl:value-of select="title"/>
			</a>
		</h2>

		<p class="info">
			<xsl:call-template name="format-date">
				<xsl:with-param name="date" select="date/full"/>
				<xsl:with-param name="format" select="'M x, Y'"/>
			</xsl:call-template>
			<xsl:text> | </xsl:text>
			<xsl:for-each select="tags/tag">
				<a href="/tag/{.}">
					<xsl:value-of select="."/>
				</a>
				<xsl:text> </xsl:text>
			</xsl:for-each>
			<xsl:text> | </xsl:text>
			<xsl:value-of select="$root/meta/author"/>
		</p>

		<xsl:apply-templates select="content/node()" mode="xhtml"/>
	</div>
</xsl:template>

</xsl:stylesheet>
