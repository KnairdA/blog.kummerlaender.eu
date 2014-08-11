<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="target/03_meta/categories.xml" target="category"/>
	<datasource type="support" mode="full"    source="target/03_meta/meta.xml"       target="meta"/>
	<target     mode="xpath"   value="concat(xalan:nodeset($datasource)/datasource/category/entry/@handle, '/index.html')"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/category/entry/@handle"/>
</xsl:template>

<xsl:template match="category/entry">
	<div class="archiv columns">
		<ul class="prettylist">
			<xsl:apply-templates />
		</ul>
	</div>
</xsl:template>

<xsl:template match="category/entry/page">
	<li>
		<em>»</em>
		<a href="{$url}/page/{@handle}">
			<strong><xsl:value-of select="title"/></strong>
			<p>
				<xsl:copy-of select="digest/node()"/>
			</p>
		</a>
	</li>
</xsl:template>

</xsl:stylesheet>
