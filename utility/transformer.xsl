<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:template name="transformer">
	<xsl:param name="input"/>
	<xsl:param name="transformation"/>

	<xsl:copy-of select="InputXSLT:transform(
		$input,
		string($transformation)
	)/self::transformation/*"/>
</xsl:template>

</xsl:stylesheet>
