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

<xsl:variable name="meta">
	<datasource type="main"    mode="full" source="target/02_data/articles.xml" target="articles"/>
	<datasource type="support" mode="full" source="target/03_meta/meta.xml"     target="meta"/>
	<target     mode="plain"   value="atom.xml"/> 
</xsl:variable>

<xsl:variable name="url" select="datasource/meta/url"/>

<xsl:template match="/">
	<feed xmlns="http://www.w3.org/2005/Atom">
		<id><xsl:value-of select="$url"/></id>
		<title><xsl:value-of select="datasource/meta/title"/></title>
		<author>
			<name>Adrian Kummerländer</name>
		</author>

		<xsl:apply-templates select="datasource/articles/entry"/>
	</feed>
</xsl:template>

<xsl:template match="datasource/articles/entry">
	<entry>
		<title><xsl:value-of select="title"/></title>
		<link><xsl:value-of select="$url"/>/article/<xsl:value-of select="@handle"/></link>
		<content type="xhtml">
			<div xmlns="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<xsl:copy-of select="content/node()"/>
			</div>
		</content>
		<published>
			<xsl:value-of select="date/full"/>
			<xsl:text>T00:00:01+02:00</xsl:text>
		</published>
	</entry>
</xsl:template>

</xsl:stylesheet>
