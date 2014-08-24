<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:output
	method="xml"
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="no"
/>

<xsl:template match="datasource">
	<xsl:variable name="total_count"   select="count(task)"/>
	<xsl:variable name="success_count" select="count(task[@result = 'success'])"/>

	<xsl:text>Tasks processed:  </xsl:text>
	<xsl:value-of select="$total_count"/>
	<xsl:text>&#xa;</xsl:text>
	<xsl:text>Tasks successful: </xsl:text>
	<xsl:value-of select="$success_count"/>
	<xsl:text>&#xa;</xsl:text>

	<xsl:text>▶ Generation </xsl:text>
	<xsl:choose>
		<xsl:when test="$total_count = $success_count">
			<xsl:text>successful</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>failed</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>.&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>
