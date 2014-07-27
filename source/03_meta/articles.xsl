<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:output
	method="xml"
	omit-xml-declaration="no"
	encoding="UTF-8"
	indent="yes"
/>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"  mode="full" source="target/02_data/articles.xml" target="articles"/>
	<target     mode="plain" value="articles.xml"/> 
</xsl:variable>

<xsl:key name="years" match="datasource/articles/entry/date/year/text()" use="." />

<xsl:template match="articles">
	<xsl:for-each select="entry/date/year/text()[generate-id() = generate-id(key('years',.)[1])]">
		<entry handle="{.}">
			<xsl:call-template name="get_articles">
				<xsl:with-param name="year" select="."/>
			</xsl:call-template>
		</entry>
	</xsl:for-each>
</xsl:template>

<xsl:template name="get_articles">
	<xsl:param name="year"/>

	<xsl:for-each select="/datasource/articles/entry[date/year = $year]">
		<article handle="{@handle}">
			<title>
				<xsl:value-of select="title"/>
			</title>
			<date>
				<xsl:value-of select="date/full"/>
			</date>
		</article>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
