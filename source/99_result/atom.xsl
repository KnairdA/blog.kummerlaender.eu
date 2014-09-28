<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/2005/Atom"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:output
	method="xml"
	omit-xml-declaration="no"
	encoding="UTF-8"
	indent="no"
/>

<xsl:include href="[utility/xhtml.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="full" source="01_data/articles.xml" target="articles"/>
	<datasource type="support" mode="full" source="02_meta/meta.xml"     target="meta"/>
	<target     mode="plain"   value="atom.xml"/> 
</xsl:variable>

<xsl:variable name="url"    select="datasource/meta/url"/>
<xsl:variable name="author" select="datasource/meta/author"/>

<xsl:template match="datasource">
	<feed>
		<link href="{$url}/atom.xml" rel="self"      title="/home/adrian"         type="application/atom+xml"/>
		<link href="{$url}"          rel="alternate" title="Start @ /home/adrian" type="text/xhtml"/>

		<id>
			<xsl:value-of select="concat($url, '/')"/>
		</id>
		<title>
			<xsl:value-of select="meta/title"/>
		</title>
		<author>
			<name>
				<xsl:value-of select="$author"/>
			</name>
		</author>
		<updated>
			<xsl:value-of select="articles/entry[1]/date/full"/>
			<xsl:text>T00:00:01+02:00</xsl:text>
		</updated>

		<xsl:apply-templates select="articles/entry[position() &lt;= 5]"/>
	</feed>
</xsl:template>

<xsl:template match="articles/entry">
	<entry xmlns="http://www.w3.org/2005/Atom">
		<id>
			<xsl:value-of select="$url"/>
			<xsl:text>/article/</xsl:text>
			<xsl:value-of select="@handle"/>
		</id>
		<title>
			<xsl:value-of select="title"/>
		</title>
		<link rel="alternate" title="{title}">
			<xsl:attribute name="href">
				<xsl:value-of select="$url"/>
				<xsl:text>/article/</xsl:text>
				<xsl:value-of select="@handle"/>
			</xsl:attribute>
		</link>
		<content type="xhtml">
			<div xmlns="http://www.w3.org/1999/xhtml">
				<xsl:apply-templates select="content/node()" mode="xhtml"/>
			</div>
		</content>
		<updated>
			<xsl:value-of select="date/full"/>
			<xsl:text>T00:00:01+02:00</xsl:text>
		</updated>
	</entry>
</xsl:template>

</xsl:stylesheet>
