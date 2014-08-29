<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"  mode="full" source="02_data/articles.xml" target="articles"/>
	<target     mode="plain" value="paginated_articles.xml"/> 
</xsl:variable>

<xsl:variable name="total" select="floor(count(datasource/articles/entry) div 2)"/>

<xsl:template match="articles/entry[position() mod 2 = 1]">
	<entry index="{floor(position() div 2)}" total="{$total}">
		<xsl:apply-templates mode="group" select=". | following-sibling::entry[not(position() > 1)]"/>
	</entry>
</xsl:template>

<xsl:template match="articles/entry" mode="group">
	<article handle="{@handle}"/>
</xsl:template>

</xsl:stylesheet>
