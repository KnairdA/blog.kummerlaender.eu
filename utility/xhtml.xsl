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

<xsl:template match="comment() | processing-instruction()" mode="xhtml">
    <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
