<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"  mode="full" source="01_data/articles.xml" target="articles"/>
	<target     mode="plain" value="paginated_articles.xml"/>
</xsl:variable>

<xsl:variable name="page_size">3</xsl:variable>
<xsl:variable name="total" select="ceiling(count(datasource/articles/entry) div $page_size)"/>

<xsl:template match="articles/entry[position() mod $page_size = 1]">
	<entry index="{floor(position() div $page_size)}" total="{$total}">
		<xsl:apply-templates mode="group" select=". | following-sibling::entry[not(position() > ($page_size - 1))]"/>
	</entry>
</xsl:template>

<xsl:template match="articles/entry" mode="group">
	<article handle="{@handle}"/>
</xsl:template>

</xsl:stylesheet>
