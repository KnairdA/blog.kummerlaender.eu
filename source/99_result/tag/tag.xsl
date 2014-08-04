<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="target/03_meta/tags.xml" target="tag"/>
	<datasource type="support" mode="full"    source="target/03_meta/meta.xml" target="meta"/>
	<target     mode="xpath"   value="concat(xalan:nodeset($datasource)/datasource/tag/entry/@handle, '/index.html')"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/tag/entry/@handle"/>
</xsl:template>

<xsl:template match="tag/entry">
	<div class="archiv left articlelist archivlist">
		All articles tagged as &#187;<xsl:value-of select="@handle"/>&#171;
		<ol>
			<xsl:apply-templates />
		</ol>
	</div>
</xsl:template>

<xsl:template match="tag/entry/article">
	<li>
		<xsl:value-of select="date"/> » <a href="{$url}/article/{@handle}"><xsl:value-of select="title"/></a>
	</li>
</xsl:template>

</xsl:stylesheet>
