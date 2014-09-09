<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
>

<xsl:include href="[utility/master.xsl]"/>

<xsl:variable name="meta">
	<datasource type="main"    mode="iterate" source="02_meta/categories.xml" target="category"/>
	<datasource type="support" mode="full"    source="02_meta/meta.xml"       target="meta"/>
	<target     mode="xpath"   value="concat($datasource/category/entry/@handle, '/index.html')"/>
</xsl:variable>

<xsl:template name="title-text">
	<xsl:value-of select="/datasource/category/entry/@handle"/>
</xsl:template>

<xsl:template match="entry/page">
	<li>
		<em>»</em>
		<a href="/page/{@handle}">
			<strong><xsl:value-of select="title"/></strong>
			<p>
				<xsl:copy-of select="digest/node()"/>
			</p>
		</a>
	</li>
</xsl:template>

<xsl:template match="category/entry">
	<h3>
		<xsl:text>All pages categorized as &#187;</xsl:text>
		<xsl:value-of select="@handle"/>
		<xsl:text>&#171;</xsl:text>
	</h3>
	<div class="archiv columns">
		<ul class="prettylist">
			<xsl:apply-templates select="page">
				<xsl:sort select="digest/@size" data-type="number" order="descending"/>
			</xsl:apply-templates>
		</ul>
	</div>
</xsl:template>

</xsl:stylesheet>
