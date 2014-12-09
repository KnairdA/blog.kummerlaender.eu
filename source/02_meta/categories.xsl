<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="xpath" source="$source_tree/directory[@name = '00_content']/directory" target="files"/>
	<datasource type="support" mode="full"  source="01_data/pages.xml"                                      target="pages"/>
	<target     mode="plain"   value="categories.xml"/> 
</xsl:variable>

<xsl:template match="pages/entry" mode="resolve">
	<page handle="{@handle}">
		<title>
			<xsl:value-of select="title"/>
		</title>
		<digest size="{string-length(content/p[1])}">
			<xsl:copy-of select="content/p[1]/node()"/>
		</digest>
	</page>
</xsl:template>

<xsl:template match="files/directory[@name = 'pages']/directory">
	<entry handle="{@name}">
		<xsl:apply-templates />
	</entry>
</xsl:template>

<xsl:template match="files/directory[@name = 'pages']/*/file[@extension = '.md']">
	<xsl:variable name="handle" select="@name"/>

	<xsl:apply-templates select="$root/pages/entry[@handle = $handle]" mode="resolve"/>
</xsl:template>

</xsl:stylesheet>
