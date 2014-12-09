<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="full" source="01_data/tags.xml"     target="tags"/>
	<datasource type="support" mode="full" source="01_data/articles.xml" target="articles"/>
	<target     mode="plain"   value="tags.xml"/> 
</xsl:variable>

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

<xsl:template match="tags/entry">
	<entry handle="{@handle}">
		<xsl:apply-templates />
	</entry>
</xsl:template>

<xsl:template match="tags/*/article">
	<xsl:variable name="handle" select="@handle"/>

	<xsl:apply-templates select="$root/articles/entry[@handle = $handle]" mode="resolve"/>
</xsl:template>

</xsl:stylesheet>
