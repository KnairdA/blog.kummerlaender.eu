<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:template name="plain_formatter">
	<xsl:param name="format"/>
	<xsl:param name="source"/>

	<xsl:copy-of select="InputXSLT:external-command(
		$format,
		$source
	)/self::command/node()"/>
</xsl:template>

<xsl:template name="math_highlighter">
	<xsl:param name="source"/>
	<xsl:param name="arguments"/>

	<xsl:variable name="formatted_expression">
		<xsl:call-template name="plain_formatter">
			<xsl:with-param name="format">
				<xsl:text>katex </xsl:text>
				<xsl:value-of select="$arguments"/>
			</xsl:with-param>
			<xsl:with-param name="source" select="$source"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:copy-of select="xalan:nodeset($formatted_expression)/node()"/>
</xsl:template>

<xsl:template name="code_highlighter">
	<xsl:param name="source"/>
	<xsl:param name="language"/>

	<xsl:variable name="formatted_code">
		<xsl:call-template name="plain_formatter">
			<xsl:with-param name="format">
				<xsl:text>highlight --out-format=xhtml --inline-css --style=molokai --fragment --enclose-pre --wrap-simple --syntax=</xsl:text>
				<xsl:value-of select="$language"/>
			</xsl:with-param>
			<xsl:with-param name="source" select="$source"/>
		</xsl:call-template>
	</xsl:variable>

	<pre>
		<xsl:copy-of select="xalan:nodeset($formatted_code)/pre/node()"/>
	</pre>
</xsl:template>

<xsl:template match="@*|node()" mode="embellish">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()" mode="embellish"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="h2" mode="embellish">
	<h3>
		<xsl:apply-templates select="node()" mode="embellish"/>
	</h3>
</xsl:template>

<xsl:template match="h3" mode="embellish">
	<h4>
		<xsl:apply-templates select="node()" mode="embellish"/>
	</h4>
</xsl:template>

<xsl:template match="pre" mode="embellish">
	<xsl:call-template name="code_highlighter">
		<xsl:with-param name="source" select="code/text()"/>
		<xsl:with-param name="language">
			<xsl:choose>
				<xsl:when test="code/@class">
					<xsl:value-of select="substring(code/@class, 10, string-length(code/@class))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>txt</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="script" mode="embellish">
	<xsl:choose>
		<xsl:when test="contains(@type, 'mode=display')">
			<p class="math">
				<xsl:call-template name="math_highlighter">
					<xsl:with-param name="source" select="text()"/>
					<xsl:with-param name="arguments">
						<xsl:text>--display-mode</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</p>
		</xsl:when>
		<xsl:otherwise>
			<span class="math">
				<xsl:call-template name="math_highlighter">
					<xsl:with-param name="source"    select="text()"/>
				</xsl:call-template>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="formatter">
	<xsl:param name="source"/>

	<xsl:variable name="content">
		<xsl:call-template name="plain_formatter">
			<xsl:with-param name="format">kramdown</xsl:with-param>
			<xsl:with-param name="source" select="$source"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:apply-templates select="xalan:nodeset($content)" mode="embellish"/>
</xsl:template>

</xsl:stylesheet>
