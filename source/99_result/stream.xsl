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
	<datasource type="main"    mode="iterate" source="02_meta/paginated_articles.xml" target="page"/>
	<datasource type="support" mode="full"    source="02_meta/meta.xml"               target="meta"/>
	<datasource type="support" mode="full"    source="01_data/articles.xml"           target="articles"/>
	<target     mode="xpath"   value="concat($datasource/page/entry/@index, '/index.html')"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:choose>
		<xsl:when test="/datasource/page/entry/@index = 0">
			<xsl:text>Start</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Page </xsl:text>
			<xsl:value-of select="/datasource/page/entry/@index"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="page/entry">
	<div>
		<xsl:apply-templates select="article"/>
	</div>

	<div id="pagination">
		<xsl:if test="@index > 0">
			<span>
				<a class="pagination-previous" href="/{@index - 1}">
					<xsl:text>« newer</xsl:text>
				</a>
			</span>
		</xsl:if>
		<xsl:if test="@index &lt; @total - 1">
			<span>
				<a class="pagination-next" href="/{@index + 1}">
					<xsl:text>older »</xsl:text>
				</a>
			</span>
		</xsl:if>
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
</xsl:template>


</xsl:stylesheet>
