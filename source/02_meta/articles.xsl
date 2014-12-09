<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"  mode="full" source="01_data/articles.xml" target="articles"/>
	<target     mode="plain" value="articles.xml"/> 
</xsl:variable>

<xsl:key name="years" match="datasource/articles/entry/date/year/text()" use="."/>

<xsl:template match="articles/entry" mode="resolve">
	<article handle="{@handle}">
		<title>
			<xsl:value-of select="title"/>
		</title>
		<date>
			<xsl:value-of select="date/full"/>
		</date>
	</article>
</xsl:template>

<xsl:template match="articles">
	<xsl:for-each select="entry/date/year/text()[generate-id() = generate-id(key('years',.)[1])]">
		<xsl:variable name="year" select="."/>

		<entry handle="{.}">
			<xsl:apply-templates select="$root/articles/entry[./date/year = $year]" mode="resolve"/>
		</entry>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
