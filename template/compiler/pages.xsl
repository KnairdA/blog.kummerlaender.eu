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

<xsl:variable name="datasources">
	<file name="pages.xml"/>
</xsl:variable>

<xsl:template match="datasource[@name = 'pages.xml']/entry">
	<compile>Compile page: <xsl:value-of select="@handle"/></compile>
</xsl:template>

</xsl:stylesheet>
