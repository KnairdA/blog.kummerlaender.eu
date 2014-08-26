<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
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

<xsl:template name="page_entry">
	<xsl:param name="source"/>

	<li>
		<em>»</em>
		<a href="{$url}/page/{$source/@handle}">
			<strong><xsl:value-of select="$source/title"/></strong>
			<p>
				<xsl:copy-of select="$source/digest/node()"/>
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
			<xsl:variable name="ceiling"  select="count(page) + 1"/>
			<xsl:variable name="boundary" select="$ceiling div 2"/>

			<xsl:variable name="sorted_pages">
				<xsl:for-each select="page">
					<xsl:sort select="digest/@size" order="ascending"/>
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:variable>

			<xsl:for-each select="xalan:nodeset($sorted_pages)/page">
				<xsl:variable name="index" select="position()"/>

				<xsl:if test="$index &lt;= $boundary">
					<xsl:call-template name="page_entry">
						<xsl:with-param name="source" select="."/>
					</xsl:call-template>

					<xsl:if test="$ceiling - $index != $index">
						<xsl:call-template name="page_entry">
							<xsl:with-param name="source" select="xalan:nodeset($sorted_pages)/page[$ceiling - $index]"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</ul>
	</div>
</xsl:template>

</xsl:stylesheet>
