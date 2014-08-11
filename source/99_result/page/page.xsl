<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="target/02_data/pages.xml" target="page"/>
	<datasource type="support" mode="full"    source="target/03_meta/meta.xml"  target="meta"/>
	<target     mode="xpath"   value="concat(xalan:nodeset($datasource)/datasource/page/entry/@handle, '/index.html')"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/page/entry/title"/>
</xsl:template>

<xsl:template match="page/entry">
	<div class="last article">
		<h2>
			<xsl:text>» </xsl:text>
			<a href="{$url}/page/{@handle}">
				<xsl:value-of select="title"/>
			</a>
		</h2>
		<p class="info"/>
		<xsl:copy-of select="content/*"/>
	</div>
</xsl:template>

</xsl:stylesheet>
