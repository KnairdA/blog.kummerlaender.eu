<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="full" source="target/02_data/tags.xml"     target="tags"/>
	<datasource type="support" mode="full" source="target/02_data/articles.xml" target="articles"/>
	<target     mode="plain"   value="tags.xml"/> 
</xsl:variable>

<xsl:template name="get_article_data">
	<xsl:param name="handle"/>

	<xsl:variable name="article" select="$root/articles/entry[@handle = $handle]/*[self::title | self::date]"/>

	<title>
		<xsl:value-of select="$article/self::title"/>
	</title>
	<date>
		<xsl:value-of select="$article/self::date/full"/>
	</date>
</xsl:template>

<xsl:template match="tags/entry">
	<entry handle="{@handle}">
		<xsl:apply-templates />
	</entry>
</xsl:template>

<xsl:template match="tags/*/article">
	<article handle="{@handle}">
		<xsl:call-template name="get_article_data">
			<xsl:with-param name="handle" select="@handle"/>
		</xsl:call-template>
	</article>
</xsl:template>

</xsl:stylesheet>
