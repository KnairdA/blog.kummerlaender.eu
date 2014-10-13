<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/datasource.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"  mode="xpath" source="$source_tree/directory[@name = '00_content']/directory" target="files"/>
	<target     mode="plain" value="tags.xml"/> 
</xsl:variable>

<xsl:template match="files/directory[@name = 'tags']/directory">
	<entry handle="{@name}">
		<xsl:apply-templates select="file">
			<xsl:sort select="@name" order="descending"/>
		</xsl:apply-templates>
	</entry>
</xsl:template>

<xsl:template match="directory[@name = 'tags']/*/file[@extension = '.md']">
	<article handle="{substring(@name, 12, string-length(@name))}"/>
</xsl:template>

</xsl:stylesheet>
