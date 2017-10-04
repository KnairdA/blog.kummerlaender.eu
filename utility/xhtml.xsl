<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:template match="*" mode="xhtml">
	<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates select="node()" mode="xhtml"/>
	</xsl:element>
</xsl:template>

<xsl:template match="span" mode="xhtml">
	<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates select="node()" mode="xhtml"/>
		<xsl:if test="not(node())">
			<xsl:comment></xsl:comment>
		</xsl:if>
	</xsl:element>
</xsl:template>

<xsl:template match="comment() | processing-instruction()" mode="xhtml">
	<xsl:copy/>
</xsl:template>

<xsl:template match="a[@class = 'footnoteRef']" mode="xhtml">
	<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
		<xsl:copy-of select="@class"/>
		<xsl:copy-of select="@id"/>
		<xsl:attribute name="href">
			<xsl:value-of select="concat('/article/', ancestor::entry/@handle, '/', @href)"/>
		</xsl:attribute>
		<xsl:apply-templates select="node()" mode="xhtml"/>
	</xsl:element>
</xsl:template>

<xsl:template match="div[@class = 'footnotes']/ol/li/p/a[@class = 'more']" mode="xhtml">
	<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
		<xsl:copy-of select="@class"/>
		<xsl:attribute name="href">
			<xsl:value-of select="concat('/article/', ancestor::entry/@handle, '/', @href)"/>
		</xsl:attribute>
		<xsl:apply-templates select="node()" mode="xhtml"/>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
