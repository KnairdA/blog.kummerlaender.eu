<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:include href="[utility/formatter.xsl]"/>
<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"  mode="xpath" source="$source_tree/directory[@name = '00_content']/directory" target="files"/>
	<target     mode="plain" value="pages.xml"/> 
</xsl:variable>

<xsl:template match="files/directory[@name = 'pages']//file[@extension = '.md']">
	<xsl:variable name="content">
		<xsl:call-template name="formatter">
			<xsl:with-param name="source" select="InputXSLT:read-file(./full)/text()"/>
		</xsl:call-template>
	</xsl:variable>

	<entry handle="{@name}">
		<title>
			<xsl:value-of select="xalan:nodeset($content)/h1"/>
		</title>
		<content>
			<xsl:copy-of select="xalan:nodeset($content)/*[name() != 'h1']"/>
		</content>
	</entry>
</xsl:template>

</xsl:stylesheet>
