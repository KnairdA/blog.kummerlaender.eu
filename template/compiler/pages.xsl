<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:output
	method="xml"
	omit-xml-declaration="no"
	encoding="UTF-8"
	indent="yes"
/>

<xsl:include href="utility/context.xsl"/>

<xsl:variable name="context" select="/data/meta"/>

<xsl:variable name="datasources">
	<file name="pages.xml"/>
</xsl:variable>

<xsl:template match="datasource[@name = 'pages.xml']/entry">
	<xsl:call-template name="generate_in_context">
		<xsl:with-param name="input"          select="."/>
		<xsl:with-param name="transformation" select="string('[template/output/page.xsl]')"/>
		<xsl:with-param name="target"         select="concat($context/target/output, '/pages/', @handle)"/>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
