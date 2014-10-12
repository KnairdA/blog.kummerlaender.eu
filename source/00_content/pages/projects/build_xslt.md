# BuildXSLT

…is a simple XSLT build system for InputXSLT based applications.

It aims to provide a foundation for building more complex applications such as a fully fledged [static site generator] by enabling users to define _XML Makefiles_ instead of manually calling single [InputXSLT] transformations.

The source code of _BuildXSLT_ is available on both my [Github] profile and [cgit].

## Current features

* processing tasks contained within _XML Makefiles_
* generating single transformations
* generating chained transformations
* using external modules such as [StaticXSLT]
* using files or embedded XML-trees as transformation input

## Usage example

While _BuildXSLT_ offers enough flexibility for all kinds of different XSLT based generation tasks it was specifically built to cater for the requirements of the [static site generator] this site is built with. As such its module definition file and the _XML Makefile_ used to call it makes for the best demonstration of what one can do with _BuildXSLT_:

~~~
<transformation mode="chain">
    <link>src/steps/list.xsl</link>
    <link>src/steps/plan.xsl</link>
    <link>src/steps/process.xsl</link>
    <link>src/steps/summarize.xsl</link>
</transformation>
~~~
{: .language-xsl}

~~~
<task type="module">
	<input mode="embedded">
		<datasource>
			<meta>
				<source>source</source>
				<target>target</target>
			</meta>
		</datasource>
	</input>
	<definition mode="file">[StaticXSLT.xml]</definition>
</task>
~~~
{: .language-xsl}

[InputXSLT]: /page/input_xslt/
[static site generator]: /page/static_xslt/
[StaticXSLT]: /page/static_xslt/
[Github]: https://github.com/KnairdA/BuildXSLT/
[cgit]: http://code.kummerlaender.eu/BuildXSLT/
