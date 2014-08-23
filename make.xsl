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

<xsl:include href="utility/helper.xsl"/>

<xsl:template name="generate">
	<xsl:param name="input"/>
	<xsl:param name="transformation"/>

	<xsl:copy-of select="InputXSLT:generate(
		$input,
		string($transformation)
	)/self::generation/node()"/>
</xsl:template>

<xsl:template match="/">
	<xsl:variable name="source">source</xsl:variable>
	<xsl:variable name="target">target</xsl:variable>

	<xsl:call-template name="generate">
		<xsl:with-param name="input">
			<xsl:call-template name="merge_datasource">
				<xsl:with-param name="main">
					<xsl:call-template name="generate">
						<xsl:with-param name="input">
							<datasource>
								<xsl:value-of select="$source"/>
							</datasource>
						</xsl:with-param>
						<xsl:with-param name="transformation">list.xsl</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="support">
					<meta>
						<source><xsl:value-of select="$source"/></source>
						<target><xsl:value-of select="$target"/></target>
					</meta>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:with-param>
		<xsl:with-param name="transformation">traverse.xsl</xsl:with-param>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
