<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:include href="master.xsl"/>
<xsl:include href="[utility/date-time.xsl]"/>

<xsl:template name="title-text">
	<xsl:value-of select="/entry/h1"/> @ /home/adrian
</xsl:template>

<xsl:template match="data/entry">
	<div class="last article">
		<xsl:copy-of select="./*"/>
	</div>
</xsl:template>

</xsl:stylesheet>
