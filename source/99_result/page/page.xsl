<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="01_data/pages.xml" target="page"/>
	<datasource type="support" mode="full"    source="02_meta/meta.xml"  target="meta"/>
	<target     mode="xpath"   value="concat($datasource/page/entry/@handle, '/index.html')"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/page/entry/title"/>
</xsl:template>

<xsl:template match="page/entry">
	<div class="last article">
		<h2>
			<xsl:text>» </xsl:text>
			<a href="/page/{@handle}">
				<xsl:value-of select="title"/>
			</a>
		</h2>
		<p class="info"/>
		<xsl:copy-of select="content/*"/>
	</div>
</xsl:template>

</xsl:stylesheet>
