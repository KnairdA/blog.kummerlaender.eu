<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:output
	method="xml"
	omit-xml-declaration="no"
	encoding="UTF-8"
	indent="no"
/>

<xsl:variable name="meta">
	<datasource type="main"    mode="full" source="02_data/articles.xml" target="articles"/>
	<datasource type="support" mode="full" source="03_meta/meta.xml"     target="meta"/>
	<target     mode="plain"   value="atom.xml"/> 
</xsl:variable>

<xsl:variable name="url"    select="datasource/meta/url"/>
<xsl:variable name="author" select="datasource/meta/author"/>

<xsl:template match="*" mode="xhtml_copy">
	<xsl:element name="{name()}" namespace="http://www.w3.org/1999/xhtml">
		<xsl:apply-templates select="@*|node()" mode="xhtml_copy" />
	</xsl:element>
</xsl:template>

<xsl:template match="@*|text()|comment()" mode="xhtml_copy">
	<xsl:copy/>
</xsl:template>

<xsl:template match="/">
	<feed xmlns="http://www.w3.org/2005/Atom">
		<id><xsl:value-of select="$url"/></id>
		<title><xsl:value-of select="datasource/meta/title"/></title>
		<author>
			<name>
				<xsl:value-of select="$author"/>
			</name>
		</author>

		<xsl:apply-templates select="datasource/articles/entry[position() &lt;= 5]"/>
	</feed>
</xsl:template>

<xsl:template match="datasource/articles/entry">
	<entry xmlns="http://www.w3.org/2005/Atom">
		<title><xsl:value-of select="title"/></title>
		<link><xsl:value-of select="$url"/>/article/<xsl:value-of select="@handle"/></link>
		<content type="xhtml">
			<div xmlns="http://www.w3.org/1999/xhtml">
				<xsl:apply-templates mode="xhtml_copy" select="content/node()" />
			</div>
		</content>
		<updated>
			<xsl:value-of select="date/full"/>
			<xsl:text>T00:00:01+02:00</xsl:text>
		</updated>
	</entry>
</xsl:template>

</xsl:stylesheet>
