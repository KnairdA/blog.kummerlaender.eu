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
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="yes"
/>

<xsl:include href="utility/transformer.xsl"/>

<xsl:template match="meta">
	<xsl:call-template name="transformer">
		<xsl:with-param name="input">
			<data>
				<xsl:copy-of select="."/>
				<xsl:call-template name="transformer">
					<xsl:with-param name="input">
						<data>
							<xsl:copy-of select="."/>
							<xsl:call-template name="transformer">
								<xsl:with-param name="input" select="."/>
								<xsl:with-param name="transformation">[source.xsl]</xsl:with-param>
							</xsl:call-template>
						</data>
					</xsl:with-param>
					<xsl:with-param name="transformation">[datasource.xsl]</xsl:with-param>
				</xsl:call-template>
			</data>
		</xsl:with-param>
		<xsl:with-param name="transformation">[result.xsl]</xsl:with-param>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
