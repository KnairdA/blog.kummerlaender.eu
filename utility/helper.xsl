<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:template name="formatter">
	<xsl:param name="format"/>
	<xsl:param name="source"/>

	<xsl:copy-of select="InputXSLT:external-command(
		$format,
		$source
	)/self::command/node()"/>
</xsl:template>

<xsl:template name="cleaner">
	<xsl:param name="path"/>

	<cleaning path="./{$path}" result="{InputXSLT:external-command(
		concat('rm -r ./', $path, '/*')
	)/self::command/@result}"/>
</xsl:template>

<xsl:template name="linker">
	<xsl:param name="from"/>
	<xsl:param name="to"/>

	<linkage from="{$from}" to="{$to}" result="{InputXSLT:external-command(
		concat('ln -s ', $from, ' ./', $to)
	)/self::command/@result}"/>
</xsl:template>
</xsl:stylesheet>
