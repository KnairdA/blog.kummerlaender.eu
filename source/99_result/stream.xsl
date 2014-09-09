<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>
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

<xsl:template name="get_article">
	<xsl:param name="handle"/>

	<xsl:variable name="article" select="$root/articles/entry[@handle = $handle]"/>

	<h2>
		<xsl:text>» </xsl:text>
		<a href="/article/{$handle}">
			<xsl:value-of select="$article/title"/>
		</a>
	</h2>
	<p class="info">
		<xsl:call-template name="format-date">
			<xsl:with-param name="date" select="$article/date/full"/>
			<xsl:with-param name="format" select="'M x, Y'"/>
		</xsl:call-template> 
		<xsl:text> | </xsl:text>
		<xsl:for-each select="$article/tags/tag">
			<a href="/tag/{.}">
				<xsl:value-of select="."/>
			</a>
		</xsl:for-each>
		<xsl:text> | </xsl:text>
		<xsl:value-of select="$root/meta/author"/>
	</p>
	<xsl:copy-of select="$article/content/*"/>
</xsl:template>

<xsl:template match="page/entry">
	<xsl:apply-templates />

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

<xsl:template match="page/entry/article">
	<xsl:choose>
		<xsl:when test="position() = last()">
			<div class="last article">
				<xsl:call-template name="get_article">
					<xsl:with-param name="handle" select="@handle"/>
				</xsl:call-template>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<div class="article">
				<xsl:call-template name="get_article">
					<xsl:with-param name="handle" select="@handle"/>
				</xsl:call-template>
			</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
