<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:InputXSLT="function.inputxslt.application"
	exclude-result-prefixes="xalan InputXSLT"
>

<xsl:include href="[utility/datasource.xsl]"/>
<xsl:include href="[utility/formatter.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"  mode="full" source="target/01_files/source.xml" target="files"/>
	<target     mode="plain" value="articles.xml"/> 
</xsl:variable>

<xsl:template match="@*|node()" mode="embellish">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()" mode="embellish"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="pre" mode="embellish">
	<xsl:variable name="formatted_code">
		<xsl:call-template name="formatter">
			<xsl:with-param name="format">
				<xsl:text>highlight --out-format=xhtml --inline-css --style=molokai --fragment --enclose-pre --wrap-simple --syntax=</xsl:text>
				<xsl:choose>
					<xsl:when test="code/@class">
						<xsl:value-of select="substring(code/@class, 10, string-length(code/@class))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>txt</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="source" select="code/text()"/>
		</xsl:call-template>
	</xsl:variable>

	<pre>
		<xsl:copy-of select="xalan:nodeset($formatted_code)/pre/node()"/>
	</pre>
</xsl:template>

<xsl:template name="list_tags">
	<xsl:param name="path"/>

	<xsl:for-each select="$root/files/tags/*[./file/full = $path]">
		<tag><xsl:value-of select="name()"/></tag>
	</xsl:for-each>
</xsl:template>

<xsl:template match="files/articles">
	<xsl:apply-templates select="file">
		<xsl:sort select="name" order="descending"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="files/articles/file[./extension = '.md']">
	<xsl:variable name="content">
		<xsl:call-template name="formatter">
			<xsl:with-param name="format">kramdown</xsl:with-param>
			<xsl:with-param name="source" select="InputXSLT:read-file(./full)/text()"/>
		</xsl:call-template>
	</xsl:variable>

	<entry handle="{substring(./name, 12, string-length(./name))}">
		<title>
			<xsl:value-of select="xalan:nodeset($content)/h1"/>
		</title>
		<date>
			<full>
				<xsl:value-of select="substring(./name, 0, 11)"/>
			</full>
			<year>
				<xsl:value-of select="substring(./name, 0, 5)"/>
			</year>
		</date>
		<tags>
			<xsl:call-template name="list_tags">
				<xsl:with-param name="path" select="./full"/>
			</xsl:call-template>
		</tags>
		<content>
			<xsl:apply-templates select="xalan:nodeset($content)/*[name() != 'h1']" mode="embellish"/>
		</content>
	</entry>
</xsl:template>

</xsl:stylesheet>
