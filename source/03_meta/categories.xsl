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
	<datasource type="main"    mode="full" source="target/01_files/source.xml" target="files"/>
	<datasource type="support" mode="full" source="target/02_data/pages.xml"   target="pages"/>
	<target     mode="plain"   value="categories.xml"/> 
</xsl:variable>

<xsl:template name="get_page_data">
	<xsl:param name="handle"/>

	<xsl:variable name="page" select="$root/pages/entry[@handle = $handle]"/>

	<title>
		<xsl:value-of select="$page/title"/>
	</title>
	<digest>
		<xsl:copy-of select="$page/content/p[1]/node()"/>
	</digest>
</xsl:template>

<xsl:template match="files/pages/*[name() != 'file']">
	<entry handle="{name()}">
		<xsl:apply-templates />
	</entry>
</xsl:template>

<xsl:template match="files/pages/*/file[./extension = '.md']">
	<page handle="{./name}">
		<xsl:call-template name="get_page_data">
			<xsl:with-param name="handle" select="./name"/>
		</xsl:call-template>
	</page>
</xsl:template>

</xsl:stylesheet>
