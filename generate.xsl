<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dyn="http://exslt.org/dynamic"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="dyn xalan InputXSLT"
>

<xsl:output
	method="xml"
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="yes"
/>

<xsl:template name="generator">
	<xsl:param name="input"/>
	<xsl:param name="transformation"/>
	<xsl:param name="target"/>

	<xsl:copy-of select="InputXSLT:generate(
		$input,
		$transformation,
		$target
	)/self::generation"/>
</xsl:template>

<xsl:template name="compiler">
	<xsl:param name="input"/>
	<xsl:param name="transformation"/>
	<xsl:param name="target_prefix"/>
	<xsl:param name="target"/>

	<xsl:variable name="resolved_target">
		<xsl:choose>
			<xsl:when test="$target/@mode = 'plain'">
				<xsl:value-of select="$target/@value"/>
			</xsl:when>
			<xsl:when test="$target/@mode = 'xpath'">
				<xsl:value-of select="dyn:evaluate($target/@value)"/>
			</xsl:when>
			<xsl:otherwise>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:call-template name="generator">
		<xsl:with-param name="input"          select="$input"/>
		<xsl:with-param name="transformation" select="$transformation"/>
		<xsl:with-param name="target"         select="concat($target_prefix, '/', $resolved_target)"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="datasource">
	<xsl:param name="main"/>
	<xsl:param name="support"/>

	<datasource>
		<xsl:copy-of select="$main"/>
		<xsl:for-each select="$support">
			<xsl:element name="{./@target}">
				<xsl:choose>
					<xsl:when test="./@mode = 'full'">
						<xsl:copy-of select="InputXSLT:read-file(./@source)/self::file/*/*"/>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</datasource>
</xsl:template>

<xsl:template match="/">
	<xsl:for-each select="InputXSLT:read-directory('source/')/entry[@type = 'directory']">
		<xsl:variable name="level" select="."/>

		<xsl:for-each select="InputXSLT:read-directory(./full)/entry[./extension = '.xsl']">
			<xsl:variable name="transformation" select="."/>
			<xsl:variable name="stylesheet"     select="InputXSLT:read-file($transformation/full)/self::file/*"/>
			<xsl:variable name="meta"           select="$stylesheet/self::*[name() = 'xsl:stylesheet']/*[name() = 'xsl:variable' and @name = 'meta']"/>
			<xsl:variable name="main"           select="$meta/datasource[@type = 'main']"/>

			<xsl:choose>
				<xsl:when test="$main/@mode = 'full'">
					<xsl:call-template name="compiler">
						<xsl:with-param name="input">
							<xsl:call-template name="datasource">
								<xsl:with-param name="main">
									<xsl:element name="{$main/@target}">
										<xsl:copy-of select="InputXSLT:read-file($main/@source)/self::file/*/*"/>
									</xsl:element>
								</xsl:with-param>
								<xsl:with-param name="support" select="$meta/datasource[@type = 'support']"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="transformation" select="$stylesheet"/>
						<xsl:with-param name="target_prefix"  select="concat('target/', $level/name)"/>
						<xsl:with-param name="target"         select="$meta/target"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$main/@mode = 'iterate'">
					<xsl:variable name="datasource" select="InputXSLT:read-file($main/@source)/self::file/*"/>

					<xsl:for-each select="$datasource/entry">
						<xsl:call-template name="compiler">
							<xsl:with-param name="input">
								<xsl:call-template name="datasource">
									<xsl:with-param name="main">
										<xsl:element name="{$main/@target}">
											<xsl:copy-of select="."/>
										</xsl:element>
									</xsl:with-param>
									<xsl:with-param name="support" select="$meta/datasource[@type = 'support']"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="transformation" select="$stylesheet"/>
							<xsl:with-param name="target_prefix"  select="concat('target/', $level/name)"/>
							<xsl:with-param name="target"         select="$meta/target"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="compiler">
						<xsl:with-param name="input">
							<xsl:call-template name="datasource">
								<xsl:with-param name="support" select="$meta/datasource[@type = 'support']"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="transformation" select="$stylesheet"/>
						<xsl:with-param name="target_prefix"  select="concat('target/', $level/name)"/>
						<xsl:with-param name="target"         select="$meta/target"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
