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

<xsl:include href="utility/helper.xsl"/>

<xsl:template name="create_link">
	<xsl:param name="from"/>
	<xsl:param name="to"/>

	<xsl:value-of select="InputXSLT:external-command(
		concat('ln -sr ./', $to, ' ./', $from)
	)/self::command/@result"/>
</xsl:template>

<xsl:template name="clean">
	<xsl:param name="path"/>

	<xsl:value-of select="InputXSLT:external-command(
		concat('rm -r ./', $path, '/*')
	)/self::command/@result"/>
</xsl:template>

<xsl:template name="generate">
	<xsl:param name="input"/>
	<xsl:param name="transformation"/>
	<xsl:param name="target"/>

	<subtask>
		<xsl:attribute name="result">
			<xsl:value-of select="InputXSLT:generate(
				$input,
				$transformation,
				$target
			)/self::generation/@result"/>
		</xsl:attribute>
		<target>
			<xsl:value-of select="$target"/>
		</target>
	</subtask>
</xsl:template>

<xsl:template name="resolve_target">
	<xsl:param name="prefix"/>
	<xsl:param name="target"/>
	<xsl:param name="datasource"/>

	<xsl:choose>
		<xsl:when test="$target/@mode = 'plain'">
			<xsl:value-of select="concat($prefix, '/', $target/@value)"/>
		</xsl:when>
		<xsl:when test="$target/@mode = 'xpath'">
			<xsl:value-of select="concat($prefix, '/', dyn:evaluate($target/@value))"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="resolve_datasource">
	<xsl:param name="datasource"/>

	<xsl:for-each select="$datasource">
		<xsl:element name="{@target}">
			<xsl:choose>
				<xsl:when test="@mode = 'full'">
					<xsl:copy-of select="InputXSLT:read-file(@source)/self::file/*/*"/>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:for-each>
</xsl:template>

<xsl:template name="compile">
	<xsl:param name="main"/>
	<xsl:param name="support"/>
	<xsl:param name="transformation"/>
	<xsl:param name="target_prefix"/>
	<xsl:param name="target"/>

	<xsl:variable name="datasource">
		<xsl:call-template name="merge_datasource">
			<xsl:with-param name="main" select="$main"/>
			<xsl:with-param name="support">
				<xsl:call-template name="resolve_datasource">
					<xsl:with-param name="datasource" select="$support"/>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="resolved_target">
		<xsl:call-template name="resolve_target">
			<xsl:with-param name="prefix"     select="$target_prefix"/>
			<xsl:with-param name="target"     select="$target"/>
			<xsl:with-param name="datasource" select="$datasource"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:call-template name="generate">
		<xsl:with-param name="input"          select="$datasource"/>
		<xsl:with-param name="transformation" select="$transformation"/>
		<xsl:with-param name="target"         select="$resolved_target"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="process">
	<xsl:param name="source"/>
	<xsl:param name="target"/>

	<xsl:variable name="transformation" select="InputXSLT:read-file($source)/self::file/node()"/>
	<xsl:variable name="meta"           select="$transformation/self::*[name() = 'xsl:stylesheet']/*[name() = 'xsl:variable' and @name = 'meta']"/>
	<xsl:variable name="main_source"    select="$meta/datasource[@type = 'main']"/>
	<xsl:variable name="support_source" select="$meta/datasource[@type = 'support']"/>

	<xsl:choose>
		<xsl:when test="$main_source/@mode = 'full'">
			<xsl:call-template name="compile">
				<xsl:with-param name="main">
					<xsl:element name="{$main_source/@target}">
						<xsl:copy-of select="InputXSLT:read-file($main_source/@source)/self::file/*/*"/>
					</xsl:element>
				</xsl:with-param>
				<xsl:with-param name="support"        select="$support_source"/>
				<xsl:with-param name="transformation" select="$transformation"/>
				<xsl:with-param name="target_prefix"  select="$target"/>
				<xsl:with-param name="target"         select="$meta/target"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$main_source/@mode = 'iterate'">
			<xsl:for-each select="InputXSLT:read-file($main_source/@source)/self::file/*/entry">
				<xsl:call-template name="compile">
					<xsl:with-param name="main">
						<xsl:element name="{$main_source/@target}">
							<xsl:copy-of select="."/>
						</xsl:element>
					</xsl:with-param>
					<xsl:with-param name="support"        select="$support_source"/>
					<xsl:with-param name="transformation" select="$transformation"/>
					<xsl:with-param name="target_prefix"  select="$target"/>
					<xsl:with-param name="target"         select="$meta/target"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="compile">
				<xsl:with-param name="support"        select="$support_source"/>
				<xsl:with-param name="transformation" select="$transformation"/>
				<xsl:with-param name="target_prefix"  select="$target"/>
				<xsl:with-param name="target"         select="$meta/target"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="task[@type = 'clean']">
	<xsl:copy>
		<xsl:attribute name="result">
			<xsl:call-template name="clean">
				<xsl:with-param name="path" select="path"/>
			</xsl:call-template>
		</xsl:attribute>
		<xsl:copy-of select="@* | node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="task[@type = 'generate']">
	<xsl:variable name="results">
		<xsl:call-template name="process">
			<xsl:with-param name="source" select="source"/>
			<xsl:with-param name="target" select="target"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:copy>
		<xsl:attribute name="result">
			<xsl:choose>
				<xsl:when test="count(xalan:nodeset($results)/subtask[@result = 'success']) = count(xalan:nodeset($results)/subtask)">
					<xsl:text>success</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>error</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:copy-of select="@* | source"/>
		<xsl:copy-of select="$results"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="task[@type = 'link']">
	<xsl:copy>
		<xsl:attribute name="result">
			<xsl:call-template name="create_link">
				<xsl:with-param name="from" select="from"/>
				<xsl:with-param name="to"   select="to"/>
			</xsl:call-template>
		</xsl:attribute>
		<xsl:copy-of select="@* | node()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="datasource">
	<xsl:apply-templates select="task[@type = 'clean']"/>
	<xsl:apply-templates select="task[@type = 'generate']"/>
	<xsl:apply-templates select="task[@type = 'link']"/>
</xsl:template>

</xsl:stylesheet>