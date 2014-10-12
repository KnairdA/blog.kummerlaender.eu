# blog.kummerlaender.eu

…is the set of XSLT transformations used to generate this website.

Its MIT licensed source code is available both [Github] and [cgit].

This implementation of XSLT based solution to the problem of static site generation depends on a collection of different projects such as [InputXSLT] which adds additonal functionality to XSLT through external functions, [BuildXSLT] which implements a basic XSLT build system and [StaticXSLT] which implements a generic static site generation framework as a module for the build system.

## Overview

The first level `00_content` contains the actual content source of the blog to be generated. This includes articles and pages formatted in Markdown and meta-data such as the page title, public URL and primary author in `meta.xml`. It is notable that this first level doesn't contain any actual transformations and as such only provides a way to store the input to _levels_ further down the processing pipeline.

The second level `01_data` reads the contents of the `00_content` level and generates data sources for articles, pages and tags. These data sources contain e.g. the augmented contents of articles already converted from Markdown into _XHTML_ and separated into title, data and content areas.

The third level `02_meta` further augments and groups these data sources. For example articles are grouped by year, tags and categories are resolved and augmented with article data provided by the previous level and articles are paginated in preparation for generating the primary article stream.

Last but not least the fourth level `99_content` takes all the data sources generated in lower _levels_ and generates the actual website pages.

[Github]: https://github.com/KnairdA/blog.kummerlaender.eu/
[cgit]: http://code.kummerlaender.eu/blog.kummerlaender.eu/
[module]: /page/static_xslt/
[BuildXSLT]: /page/build_xslt/
[InputXSLT]: /page/input_xslt/
[StaticXSLT]: /page/static_xslt/
[Symphony CMS]: http://getsymphony.com
