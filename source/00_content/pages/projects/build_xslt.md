# BuildXSLT

…is a simple XSLT build system for InputXSLT based applications.

It aims to provide a foundation for building more complex applications such as a fully fledged [static site generator] by enabling users to define _XML Makefiles_ instead of manually calling single [InputXSLT] transformations.

The source code of BuildXSLT is available on both my [Github] profile and [cgit].

## Current features

* processing tasks contained within _XML Makefiles_
* generating single transformations
* generating chained transformations
* using files or embedded XML-trees as transformation input

## Usage example

While BuildXSLT offers enough flexibility for all kinds of different XSLT based generation tasks it was specifically built to cater for the requirements of the [static site generator] this site is built with. As such its _XML Makefile_ makes for the best demonstration of what one can do with BuildXSLT:

~~~
<task type="generate">
	<input mode="embedded">
		<datasource>
			<meta>
				<source>source</source>
				<target>target</target>
			</meta>
		</datasource>
	</input>
	<transformation mode="chain">
		<link>detail/list.xsl</link>
		<link>detail/plan.xsl</link>
		<link>detail/process.xsl</link>
		<link>detail/summarize.xsl</link>
	</transformation>
</task>
~~~
{: .language-xsl}

[InputXSLT]: /page/input_xslt/
[static site generator]: /page/this_website/
[Github]: https://github.com/KnairdA/BuildXSLT/
[cgit]: http://code.kummerlaender.eu/BuildXSLT/
