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
	<datasource type="main"    mode="full" source="02_meta/paginated_articles.xml" target="paginated"/>
	<datasource type="support" mode="full" source="01_data/articles.xml"           target="articles"/>
	<datasource type="support" mode="full" source="02_meta/meta.xml"               target="meta"/>
	<target     mode="plain"   value="index.html"/>
</xsl:variable>

<xsl:template name="title-text">Start</xsl:template>

<xsl:template match="paginated">
	<div>
		<xsl:apply-templates select="entry[1]/article"/>
	</div>

	<div id="pagination">
		<span>
			<a class="pagination-next" href="/archive">
				<xsl:text>more »</xsl:text>
			</a>
		</span>
	</div>
</xsl:template>

<xsl:template match="entry/article">
	<xsl:variable name="handle" select="@handle"/>

	<div class="article">
		<xsl:apply-templates select="$root/articles/entry[@handle = $handle]" mode="resolve"/>
	</div>
</xsl:template>

<xsl:template match="articles/entry" mode="resolve">
	<h2>
		<xsl:text>» </xsl:text>
		<a href="/article/{@handle}">
			<xsl:value-of select="title"/>
		</a>
	</h2>

	<p class="info">
		<span class="spacer">
			<xsl:text>» </xsl:text>
		</span>
		<span class="text">
			<xsl:call-template name="format-date">
				<xsl:with-param name="date" select="date/full"/>
				<xsl:with-param name="format" select="'M x, Y'"/>
			</xsl:call-template>
			<xsl:text> | </xsl:text>
		</span>
		<xsl:for-each select="tags/tag">
			<a href="/tag/{.}">
				<xsl:value-of select="."/>
			</a>
			<xsl:text> </xsl:text>
		</xsl:for-each>
		<span class="text">
			<xsl:text> | </xsl:text>
			<xsl:value-of select="$root/meta/author"/>
		</span>
	</p>

	<p>
		<xsl:apply-templates select="content/p[1]/node()" mode="xhtml"/>
		<xsl:text> </xsl:text>

		<a class="more" href="/article/{@handle}">
			<xsl:text>↪</xsl:text>
		</a>
	</p>
</xsl:template>

</xsl:stylesheet>
