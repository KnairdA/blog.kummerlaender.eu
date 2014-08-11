<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:math="http://exslt.org/math"
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
	<h3>
		<xsl:text>All pages categorized as &#187;</xsl:text>
		<xsl:value-of select="@handle"/>
		<xsl:text>&#171; in random order</xsl:text>
	</h3>
	<div class="archiv columns">
		<ul class="prettylist">
			<xsl:for-each select="page">
				<xsl:sort select="position() mod math:random()" order="descending"/>

				<xsl:apply-templates select="."/>
			</xsl:for-each>
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
